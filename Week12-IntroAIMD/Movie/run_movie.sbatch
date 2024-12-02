#!/bin/bash
#SBATCH --job-name=make_movie    # 任务名称
#SBATCH --output=make_movie.out  # 标准输出文件
#SBATCH --error=make_movie.err   # 错误输出文件
#SBATCH --ntasks=1               # 任务数量
#SBATCH --cpus-per-task=10        # 每个任务使用的CPU核数
#SBATCH --time=8:00:00           # 最大运行时间
#SBATCH --partition=cs           # 指定分区（根据集群配置）

# 加载 VMD 和 ffmpeg 模块
module load vmd/1.9.3
module load ffmpeg/4.2.4

# 切换到工作目录
cd /scratch/wx2237/comp-lab-class/comp-lab-class-2024/Week12-IntroAIMD/Movie

# 运行 VMD 脚本生成帧
vmd -e make_movie.tcl

# 合并帧为视频
ffmpeg -r 30 -i frame.%04d.tga -vcodec libx264 -pix_fmt yuv420p Proton_Movie.mp4
