#!/bin/bash
# 看板と目隠しをシミュレータに出現させる。
# 使い方:  ./spawn_stage.sh            （標準の位置）
#          ./spawn_stage.sh 0.02       （左右に2cmずらす。マイナスも可。データ集めで位置を変えたいときに）
DY=${1:-0}
DIR=/workspace/stage
TABLE_Z=1.015
SIGN_X=0.15
COVER_X=0.18
SIGN_Z=$(awk "BEGIN{print $TABLE_Z + 0.025 + 0.001}")
COVER_Z=$(awk "BEGIN{print $TABLE_Z + 0.045 + 0.002}")
ros2 run ros_gz_sim create -file $DIR/hello_sign.sdf -name hello_sign -x $SIGN_X  -y $DY -z $SIGN_Z
ros2 run ros_gz_sim create -file $DIR/cover.sdf      -name cover      -x $COVER_X -y $DY -z $COVER_Z
