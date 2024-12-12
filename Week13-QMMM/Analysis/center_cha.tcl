# 选择 CHA
set sel [atomselect top "resname CHA"]

# 验证选择
puts "Number of atoms selected: [$sel num]"
puts "Selected resnames: [$sel get resname]"

# 计算几何中心
set center [measure center $sel]
puts "Center of CHA: $center"

# 将视图移动到 CHA 的几何中心
display moveby [vecscale -1 $center]

# 放大视图
scale by 2.0

# 显示 CHA 配体
mol representation CPK
mol selection "resname CHA"
mol addrep top
