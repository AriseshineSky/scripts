# 本地音乐播放设置说明

## 架构

- **MPD** —— 音乐播放守护进程（后台常驻，负责播放/队列/扫描）
- **ncmpcpp** —— 终端客户端（界面）
- **cava** —— 频谱可视化

三者由 `super+m` 一键开关，绑定在 dwm 上（`~/dwm/config.h` 的 `TAGKEYS(XK_m, 9, "~/scripts/music_player.sh")`，对应 music tag）。

## 相关文件

| 文件 | 作用 |
| --- | --- |
| `~/scripts/music_player.sh` | `super+m` 调用的开关脚本 |
| `~/.config/mpd/mpd.conf` | MPD 配置（音乐目录、音频输出、自动刷新） |
| `~/.config/mpd/state` | MPD 运行状态（上次播放队列等） |
| `~/.config/mpd/playlists/` | 已保存的播放列表 |
| `~/.config/mpd/database` | MPD 歌曲数据库 |
| `~/.config/ncmpcpp/config` | ncmpcpp 界面配置 |
| `~/.config/ncmpcpp/bindings` | ncmpcpp 按键绑定 |
| `~/dwm/config.h` | dwm 配置（`super+m` 绑定、music tag、窗口规则） |
| `~/dwm/statusbar/packages/music.sh` | 状态栏音乐模块（显示当前曲目、可点击控制） |
| `~/dwm/statusbar/statusbar.sh` | 状态栏主脚本（调度各模块刷新） |

## 工作原理

`music_player.sh` 逻辑：

1. **正在运行**：杀掉 ncmpcpp / mpd / cava（再次按 `super+m` = 关闭）
2. **没有运行**：启动 `mpd`，在屏幕右上角开一个浮动、无边框的 `st` 窗口跑 ncmpcpp，另开一个 cava 可视化窗口

窗口自动落到 music tag（9），按 `super+m` 时 dwm 会先切换到该 tag 再拉起程序。

## 音乐目录

**MPD 的音乐目录是 `~/Music`（软链到 `~/src/Music`）**。

> 不要把 mp3 放到 `~/.Music`（不存在的目录），MPD 扫不到。

### 放入新歌曲

1. 把 mp3 复制/移动到 `~/Music/`
2. 配置已开启 `auto_update yes`，稍等即自动入库；也可手动刷新：`mpc update`
3. 按 `super+m` 打开音乐窗口，或用 `mpc` 命令播放

## 使用方式

### 快捷键

| 按键 | 作用 |
| --- | --- |
| `super+m` | 打开/关闭音乐播放器 |
| `super+shift+↑ / ↓` | 音量加 / 减 |
| 窗口内 `space` | 暂停/继续 |
| 窗口内 `Enter` | 播放选中歌曲 |
| 方向键 / `e g` | 选择歌曲 |

### ncmpcpp 窗口内

- 方向键 / `e` `g` 选择歌曲，`Enter` 播放
- `space` 暂停/继续
- `L` 查看歌词
- `tab` 切换界面（播放队列 / 歌曲列表 / 等信息）
- 切歌时自动弹出系统通知显示当前歌曲

### 命令行（mpc，不开窗口也能控制）

```bash
mpc listall                    # 列出全部歌曲
mpc add "某.mp3"               # 加入播放队列
mpc toggle                     # 播放 / 暂停
mpc stop                       # 停止
mpc next                       # 下一首
mpc prev                       # 上一首
mpc seek 0                     # 当前曲目重新播放
mpc current                    # 显示当前歌曲
mpc repeat                     # 循环开关
mpc random                     # 随机开关
mpc update                     # 重新扫描音乐目录
mpc save 名字                  # 保存当前队列为播放列表
mpc load 名字                  # 载入播放列表
mpc ls                         # 查看音乐目录结构
mpc status                     # 查看播放器状态
```

### 常见问题

- **`mpc` 提示 Connection refused**：MPD 没在运行，按 `super+m` 即可启动。
- **新歌搜不到**：确认放在 `~/Music/` 下，然后 `mpc update`。
- **没有声音**：MPD 用 PulseAudio 输出，检查 `pactl info` 默认输出设备。