# Dotfiles（Chezmoi）

用户目录配置文件备份，使用 [Chezmoi](https://www.chezmoi.io/) 管理。

## 新机恢复

### 前置要求

- 已安装 [Chezmoi](https://www.chezmoi.io/install/)（见下方一键安装）
- 已安装 [age](https://github.com/FiloSottile/age)（用于解密 Raycast 等加密配置）  
  - macOS: `brew install age`

### 一键安装并应用（首次在新机）

```bash
# 安装 chezmoi 并拉取本仓库、应用到当前用户目录
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply pigstar02/dotfiles
```

若已单独安装过 chezmoi，只需拉取并应用：

```bash
chezmoi init pigstar02/dotfiles
chezmoi apply
```

### 解密加密文件（Raycast config 等）

本仓库中部分文件（如 `~/.config/raycast/config.json`）使用 age 加密存储。要正常还原，需在本机配置私钥：

1. **从旧机拷贝私钥**  
   将旧机上的 `~/.config/chezmoi/key.txt` 复制到新机同一路径（或你打算使用的路径）。

2. **在新机创建 Chezmoi 本机配置**（不提交到 Git）  
   创建并编辑 `~/.config/chezmoi/chezmoi.toml`，内容示例：

   ```toml
   encryption = "age"

   [age]
   identity = "/Users/你的用户名/.config/chezmoi/key.txt"
   recipient = "age1mnx3qaal76ccl93d38uj59w53kgalfv7magx9kt5mpq0e5k7zgmq4vunsp"
   ```

   将 `identity` 改为新机上 `key.txt` 的实际路径，`recipient` 保持与仓库中 `.chezmoi.toml` 一致即可。

3. **再次应用**  
   ```bash
   chezmoi apply
   ```

没有配置私钥时，加密文件会被跳过，其余 dotfiles 仍会正常应用。

### 恢复后建议检查

- Shell：确认 `~/.zshrc`、`~/.zprofile` 等已生效，可 `source ~/.zshrc` 或新开终端。
- Oh My Zsh / Powerlevel10k：若未安装，需自行安装后再用上述配置。
- Hammerspoon：应用后需在系统设置中允许辅助功能等权限，并重启 Hammerspoon。
- AeroSpace：需已安装 AeroSpace，否则 `~/.aerospace.toml` 不会生效。

---

## 本仓库包含的配置

| 类型       | 路径 |
|------------|------|
| Shell      | `.zshrc` `.zprofile` `.zshenv` `.bash_profile` `.bashrc` `.profile` |
| Git        | `.gitconfig` |
| 窗口管理   | `.aerospace.toml` |
| 调试       | `.lldbinit` |
| Hammerspoon| `.hammerspoon/`（不含其 `.git`） |
| Karabiner  | `.config/karabiner/karabiner.json` |
| Raycast    | `.config/raycast/config.json`（**加密**） |

---

## 日常更新（在已配置过的机器上）

修改了本机上的 dotfiles 后，同步回仓库：

```bash
chezmoi add ~/.zshrc   # 按需替换为其他路径
chezmoi status        # 查看将提交的变更
cd $(chezmoi source-path)
git add .
git commit -m "update dotfiles"
git push
```

应用仓库最新变更到本机：

```bash
chezmoi update
# 或：cd $(chezmoi source-path) && git pull && chezmoi apply
```
