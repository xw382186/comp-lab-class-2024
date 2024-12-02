# 加载输入文件
mol new /scratch/wx2237/comp-lab-class/comp-lab-class-2024/Week12-IntroAIMD/Runs/Proton/proton_aimd_1ns_every0.5fs-pos-1.xyz type xyz

# 配置显示参数
axes location off
display projection orthographic
display shadows on
display ambientocclusion on
color Display Background white

# 配置分子样式
mol modselect 0 top all
mol modstyle 0 top Licorice 0.3 10 10
mol modmaterial 0 top AOShiny
mol modcolor 0 top Name

# 设置动画帧输出路径
set output_dir /scratch/wx2237/comp-lab-class/comp-lab-class-2024/Week12-IntroAIMD/Movie
set frame_format "$output_dir/frame.%04d.tga"

# 定义拍摄函数
proc take_picture {frame_num} {
    global frame_format
    set filename [format $frame_format $frame_num]
    render TachyonInternal $filename
}

# 创建动画
display update off
set frame_num 0
for {set i 0} {$i < 360} {incr i 1} {
    rotate y by 1
    take_picture $frame_num
    incr frame_num
}
display update on

# 转换图片为视频（需要 ffmpeg 工具）
exec ffmpeg -r 30 -i "$output_dir/frame.%04d.tga" -vcodec libx264 -pix_fmt yuv420p "$output_dir/Proton_Movie.mp4"
