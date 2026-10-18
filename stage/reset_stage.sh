#!/bin/bash
# 目隠しを元の位置・まっすぐ立った向きに戻す
# 使い方: ./reset_stage.sh   （spawn_stage.sh で左右にずらした場合は同じ数字を付ける 例: ./reset_stage.sh 0.02）
DY=${1:-0}
ign service -s /world/default/set_pose \
  --reqtype ignition.msgs.Pose --reptype ignition.msgs.Boolean --timeout 2000 \
  --req "name: \"cover\", position: {x: 0.18, y: $DY, z: 1.062}, orientation: {w: 1}"
