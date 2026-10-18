# Hello World 看板の目隠しを倒す 模倣学習

Gazebo シミュレータ上の CRANE+ V2 アームを、キーボードで遠隔操作（テレオペ）して集めたお手本から模倣学習（ACT）し、学習したモデルだけで「目隠しの板を倒して、後ろの Hello World 看板を見せる」動作を再現したものです。

## 概要

- ロボット: CRANE+ V2（ROS 2 Humble / Ignition Gazebo）
- 学習手法: ACT（LeRobot）
- 入力: 関節角度のみ
- ステージ: ロボットの正面に「Hello World 看板（固定）」と、その外側に「目隠しの板（動く）」を配置。
  ロボットが目隠しを外側へ押し倒すと、看板の文字が見えるようになります。

## 使用した主なリポジトリ

- テレオペ: [matsuolab/physicalai_teleop](https://github.com/matsuolab/physicalai_teleop)
- 変換・学習・推論: [matsuolab/pai_training](https://github.com/matsuolab/pai_training)
- シミュレータ: [rt-net/crane_plus](https://github.com/rt-net/crane_plus)

## このリポジトリの内容

```
stage/                     自作のステージ
  hello_sign.sdf          Hello World 看板のモデル（固定）
  cover.sdf               目隠しの板のモデル
  spawn_stage.sh          看板と目隠しをシミュレータに出現させるスクリプト
  reset_stage.sh          目隠しを元の位置に戻すスクリプト
  textures/               看板の文字画像
configs/                   pai_training の設定ファイル（本課題用に変更したもの）
  conversion_config.yaml
  crane_features.py
  train_config.yaml
```

## 実行手順

### 1. シミュレータの起動とステージの配置

```bash
ros2 launch crane_plus_gazebo crane_plus_with_table.launch.py
/workspace/stage/spawn_stage.sh
```

### 2. テレオペでお手本を記録

```bash
ros2 run physicalai_teleop teleop_keyboard
ros2 bag record -a -o ~/dataset/rosbags/hello_world_v2/ep0   # ep1, ep2, ... と増やす
```

1 回ごとに、テレオペで `X`（直立に戻す）→ `reset_stage.sh`（目隠しを戻す）→ 記録 → 操作 → 記録停止、を繰り返しました。

操作手順（毎回同じキーと回数で操作）:

1. joint2 を選択 → S を 10 回
2. joint3 を選択 → S を 43 回
3. joint2 を選択 → W を  6 回

記録したエピソード数: 25 回

### 3. 変換・学習

`pai_training` の `configs/` を、このリポジトリの `configs/` に置き換えて実行します。

```bash
cd ~/pai_training
pixi run convert
WANDB_MODE=disabled pixi run train
```

主な学習設定（`train_config.yaml`）: training_steps 3000 / batch_size 8 / device cpu

### 4. 推論（再現）

テレオペを終了してから実行します。

```bash
pixi run infer --model-path /home/ubuntu/checkpoints/train/crane_plus_hello_world_v2_act
```

## 注意

- 記録データ（rosbag）と学習済みモデルは、容量が大きいため含めていません。