<div align="center">

<img src="assets/wukong-code-small.svg" alt="Wukong Code 標誌" width="160" />

# Wukong Code

**面向程式設計智慧體的完整軟體開發方法論**<br>
先設計 · 測試驅動開發 · 先驗證再下結論

[![授權條款：MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![版本](https://img.shields.io/github/v/tag/wukongnotnull/wukong-code?label=version)](https://github.com/wukongnotnull/wukong-code/tags)
[![外掛](https://img.shields.io/badge/type-coding%20agent%20plugin-F59E0B.svg)](https://github.com/wukongnotnull/wukong-code)
[![Stars](https://img.shields.io/github/stars/wukongnotnull/wukong-code?style=social)](https://github.com/wukongnotnull/wukong-code/stargazers)

</div>

**多語言：** [English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md)

> Wukong Code 為你的程式設計智慧體提供一套可組合的技能，以及確保技能在正確時機自動觸發的啟動指令——涵蓋需求探索、設計規劃、TDD、審查與最終驗證。

---

**快速導覽**<br>
[為什麼選擇 Wukong Code](#為什麼選擇-wukong-code) · [運作方式](#運作方式) · [安裝](#支援的智慧體與安裝方式) · [基本工作流程](#基本工作流程) · [技能庫](#包含內容) · [語言指導](#語言指導) · [測試](#測試) · [常見問題](#常見問題) · [參與貢獻](#參與貢獻) · [授權條款](#授權條款)

---

## 為什麼選擇 Wukong Code

| 能力 | 你能得到什麼 |
| --- | --- |
| **先設計再寫程式碼** | 智慧體先釐清目標、比較方案並取得確認，然後才開始實作 |
| **可執行的計畫** | 將已確認的設計拆成包含具體檔案和驗證步驟的小任務 |
| **真正的 TDD** | 強制執行 RED–GREEN–REFACTOR，而不是寫完程式碼後再補測試 |
| **系統化除錯** | 提出修正方案前先調查根因 |
| **全程審查** | 實作過程中持續檢查需求符合度與程式碼品質 |
| **先驗證再下結論** | 必須取得最新驗證結果，不能憑假設宣布完成 |
| **自動觸發** | 技能依任務情境自動啟用，不必每次輸入特殊提示詞 |

適合希望程式設計智慧體遵循可重複工程流程，而不只是快速產生程式碼的開發者。

---

## 運作方式

Wukong Code 從智慧體工作階段啟動時開始運作。它會先將請求路由到對應的軟體開發或 Product Design 工作流程，再只載入目前任務真正需要的專用技能。

### 軟體開發

當智慧體辨識到建置或行為變更任務時，它不會立即寫程式碼，而是先弄清楚你真正想達成的目標。

設計獲得確認後，智慧體會建立具體實作計畫，遵循真正的紅／綠 TDD，在適當時委派獨立任務，審查結果，並在宣布完成前驗證整個變更。

```text
你的想法
   ↓
需求探索 → 已確認的設計 → 實作計畫
   ↓
RED → GREEN → REFACTOR → 審查 → 驗證
   ↓
合併 / 建立 PR / 保留分支
```

### Product Design

Product Design 連接產品想法與可執行的軟體。存在已儲存的產品資料時，它會使用品牌素材、設計系統、螢幕截圖、元件和偏好工具作為設計依據，再依你的目標選擇對應路徑：

```text
研究或稽核
產品 / 流程 → 擷取目前證據 → UX、視覺與無障礙建議

探索新方向
設計簡報 → 3 個視覺方案 → 由你選擇 → 響應式原型

複製或實作
線上 URL 或選定視覺稿 → 前端實作 → Design QA → 預覽 / 分享
```

研究和稽核以目前擷取的證據為準，不修改原始碼。新設計必須先選定視覺方向，才能進入實作。原型交付前必須將渲染結果與視覺來源進行比較，並通過 Design QA。

技能會自動觸發，所以你只需像平常一樣與程式設計智慧體協作。軟體開發和 Product Design 流程都已內建在工作階段中，並會依目前實際可用的瀏覽器、圖像生成、本機建置和分享能力調整執行方式。

---

## 支援的智慧體與安裝方式

不同智慧體的安裝方式不同。如果同時使用多個智慧體，需要分別安裝 Wukong Code。

目前版本：**[v6.3.0](https://github.com/wukongnotnull/wukong-code/releases/tag/v6.3.0)**。此版本已停止支援 Gemini CLI，目前支援清單不再包含它。

**支援：** [Antigravity](#antigravity) · [Claude Code](#claude-code) · [Codex App](#codex-app) · [Codex CLI](#codex-cli) · [Cursor](#cursor) · [Factory Droid](#factory-droid) · [GitHub Copilot CLI](#github-copilot-cli) · [Kimi Code](#kimi-code) · [OpenCode](#opencode) · [Pi](#pi)

### Antigravity

從此儲存庫安裝外掛：

```bash
agy plugin install https://github.com/wukongnotnull/wukong-code
```

Antigravity 會執行工作階段啟動鉤子，因此 Wukong Code 從第一則訊息起就會生效。更新時重複執行相同指令。

### Claude Code

從此儲存庫安裝：

```bash
/plugin marketplace add wukongnotnull/wukong-code
/plugin install wukong-code@wukong-code
```

### Codex App

Wukong Code 已上架 [Codex 官方外掛市集](https://github.com/openai/plugins)。

1. 點選 Codex 側邊欄中的 **Plugins**。
2. 在 Coding 分類找到 **Wukong Code**。
3. 點選 `+`，依提示完成安裝。

### Codex CLI

開啟外掛介面：

```text
/plugins
```

搜尋 `wukong-code`，然後選擇 **Install Plugin**。

### Cursor

在 Cursor Agent 對話中輸入：

```text
/add-plugin wukong-code
```

也可以在外掛市集搜尋 `wukong-code`。

### Factory Droid

```bash
droid plugin marketplace add https://github.com/wukongnotnull/wukong-code
droid plugin install wukong-code@wukong-code
```

### GitHub Copilot CLI

```bash
copilot plugin marketplace add wukongnotnull/wukong-code
copilot plugin install wukong-code@wukong-code
```

### Kimi Code

開啟 `/plugins`，進入 **Marketplace → Wukong Code** 並安裝。也可以從此儲存庫直接安裝：

```text
/plugins install https://github.com/wukongnotnull/wukong-code
```

詳細說明請參閱 [Kimi Code 安裝指南](docs/README.kimi.md)。

### OpenCode

告訴 OpenCode：

```text
Fetch and follow instructions from https://raw.githubusercontent.com/wukongnotnull/wukong-code/refs/heads/main/.opencode/INSTALL.md
```

詳細說明請參閱 [OpenCode 安裝指南](docs/README.opencode.md)。

### Pi

作為 Pi 套件安裝：

```bash
pi install git:github.com/wukongnotnull/wukong-code
```

本機開發時：

```bash
pi -e /path/to/wukong-code
```

Pi 套件會載入技能，並在工作階段啟動和內容壓縮後注入 `using-wukong-code` 引導指令。Pi 原生支援技能；子智慧體與任務清單工具仍是選用的配套套件。

---

## 基本工作流程

### 軟體開發工作流程

1. **using-wukong-code** — 採取任何行動前先檢查任務，並選擇最小且適用的工作流程。
2. **brainstorming**、**systematic-debugging** 或直接處理 — 新功能先設計，根因不明的錯誤先調查，明確的機械修改直接執行。
3. **writing-plans** — 將已確認的多步驟設計拆成包含具體檔案路徑和驗證步驟的小任務。
4. **using-git-worktrees** — 執行需要隔離時建立獨立工作區，並驗證乾淨的測試基線。
5. **subagent-driven-development** 或 **executing-plans** — 透過任務層級審查或人工檢查點執行計畫；適用 TDD 時遵循 RED–GREEN–REFACTOR。
6. **verification-before-completion** 與程式碼審查 — 宣布完成前取得最新證據，並檢查完整結果。
7. **finishing-a-development-branch** — 遵循既有整合意圖；若尚未決定，則提供合併、PR、保留和捨棄選項。

**智慧體會在每個任務開始前檢查相關技能。這些工作流程是必須遵循的要求，不是建議。**

### Product Design 工作流程

1. **product-design** — 識別目標，並將請求路由到對應的 Product Design 專用技能。
2. **product-design-user-context** — 當資料能為目前任務提供依據時，載入已儲存的品牌素材、設計系統、螢幕截圖、參考資料和偏好。
3. **product-design-context** — 在視覺探索或實作前，明確設計目標、目標使用者和預期結果。
4. **product-design-research**、**product-design-audit** 或 **product-design-ideate** — 研究目前使用者痛點、稽核擷取到的產品證據，或產生三個視覺方向供使用者選擇。
5. **product-design-url-to-code** 或 **product-design-image-to-code** — 忠實複製線上 URL，或將選定視覺稿實作為響應式前端。
6. **product-design-design-qa** — 比較渲染原型與視覺來源；比較通過前阻止交付。
7. **product-design-share** — 使用者要求部署或分享時，發布可執行原型並回傳分享連結。

**這些技能不會在每次請求中依固定順序全部執行。Product Design 會依研究、稽核、創意、複製、實作、QA 或分享目標，選擇最短的適用路徑。**

---

## 包含內容

`6.3.0` 版本包含 **27 個頂層技能**：17 個通用開發技能與 10 個 Product Design 技能。

| 領域 | 技能與指導 |
| --- | --- |
| **測試** | `test-driven-development`、測試反模式 |
| **除錯** | `systematic-debugging`、根因追蹤、縱深防禦、基於條件的等待 |
| **驗證** | `verification-before-completion` |
| **規劃** | `brainstorming`、`grilling`、`writing-plans`、`executing-plans` |
| **協作** | `dispatching-parallel-agents`、`subagent-driven-development`、`requesting-code-review`、`receiving-code-review` |
| **工作區** | `using-git-worktrees`、`finishing-a-development-branch` |
| **語言實作** | 以證據為基礎的實驗性 `language-guidance` 指導套件 |
| **前端設計** | 來自 [Anthropic Skills](https://github.com/anthropics/skills/tree/main/skills/frontend-design) 的鮮明、嚴謹前端視覺設計指導 |
| **元技能** | `writing-skills`、`using-wukong-code` |

### Product Design

`6.3.0` 版本包含以下 10 個 Product Design 技能：

| 技能 | 作用 |
| --- | --- |
| `product-design` | Product Design 總入口，依目標路由到對應的專用工作流程 |
| `product-design-user-context` | 儲存或載入品牌素材、設計系統、螢幕截圖、參考資料和偏好 |
| `product-design-context` | 明確設計目標、目標使用者和預期結果 |
| `product-design-research` | 根據最新來源研究使用者痛點與產品機會 |
| `product-design-audit` | 根據目前擷取的證據稽核產品流程中的 UX、視覺與無障礙問題 |
| `product-design-ideate` | 產生三個可供比較和選擇的視覺方向 |
| `product-design-url-to-code` | 將線上 URL 忠實複製為可執行的本機前端原型 |
| `product-design-image-to-code` | 將選定視覺稿實作為響應式互動前端 |
| `product-design-design-qa` | 比較視覺來源與渲染結果，並作為原型交付門檻 |
| `product-design-share` | 使用者要求時發布可執行原型並回傳分享連結 |

這些內容匯入自 Product Design `0.1.52`，MIT 來源記錄在 [`product-design.lock.json`](product-design.lock.json) 和 [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) 中。

驗證匯入內容：

```bash
node scripts/check-product-design-import.mjs
```

---

## 語言指導

Wukong Code 的方法論保持語言無關。當儲存庫證據能確定受支援的語言和工作階段時，智慧體只載入當前所需的實作指導。指導套件不會安裝工具，也不會覆寫儲存庫定義的指令。

| 語言 | 狀態 | 實作 | 測試 | 除錯 | 審查 | 驗證 | 證據 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Go | 實驗性 | ✓ | ✓ | ✓ | ✓ | ✓ | [評估報告](docs/wukong-code/evals/2026-07-22-go-language-guidance.md) |
| Java | 實驗性 | ✓ | ✓ | ✓ | ✓ | ✓ | [評估報告](docs/wukong-code/evals/2026-08-02-java-language-guidance.md) |
| TypeScript | 規劃中 | — | — | — | — | — | — |
| Swift | 實驗性 | ✓ | ✓ | ✓ | ✓ | ✓ | [評估報告](docs/wukong-code/evals/2026-07-29-swift-language-guidance.md) |
| Rust | 實驗性 | ✓ | ✓ | ✓ | ✓ | ✓ | [評估報告](docs/wukong-code/evals/2026-07-29-rust-language-guidance.md) |

**實驗性**表示已完成初步行為評估，但仍在累積真實專案證據。框架、雲端服務、資料庫和團隊專用指導不屬於核心範圍。

---

## 測試

執行確定性的核心檢查：

```bash
npm test
```

執行核心檢查以及 brainstorm-server 和 Antigravity 檢查：

```bash
npm run test:extended
```

需要宿主 CLI、憑證或真實 LLM 工作階段的測試仍需手動執行。外掛測試入口與獨立的 [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals) 行為評估流程請參閱 [`docs/testing.md`](docs/testing.md)。

---

## 理念

| 原則 | 含義 |
| --- | --- |
| **測試驅動開發** | 永遠先寫失敗測試 |
| **系統化優於臨時發揮** | 遵循可重複流程，而不是猜測 |
| **降低複雜度** | 優先選擇最小且清晰的解決方案 |
| **證據優於聲明** | 宣布成功前先驗證 |

---

## 常見問題

**需要手動呼叫技能嗎？**<br>
不需要。正確整合的智慧體會在工作階段啟動時載入引導指令，再依任務情境選擇相關技能。

**可以在多個程式設計智慧體中安裝嗎？**<br>
可以。不同智慧體的外掛系統彼此獨立，需要分別安裝。

**如何更新？**<br>
使用對應智慧體提供的更新流程。透過儲存庫安裝時，通常可以重複安裝指令來更新版本。

**Wukong Code 會安裝專案相依套件嗎？**<br>
不會。核心維持零相依，語言指導套件也不會安裝工具或取代儲存庫定義的指令。

**行為評估在哪裡？**<br>
技能行為評估位於 [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals)，本機複製到 `evals/`；外掛基礎設施測試仍位於 `tests/`。

---

## 參與貢獻

貢獻必須解決真實經歷過的具體問題。開始前請閱讀 [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md) 和儲存庫貢獻指南。

領域專用技能與外部來源技能只要受眾明確，並能在支援的智慧體中安全維護，就可以進入核心審查。貢獻者必須揭露來源、授權條款、相依影響、測試或評估，以及維護或更新策略。除非針對智慧體支援另有明確記錄的例外，核心仍維持零相依。

1. 搜尋開放和已關閉的 PR，確認是否已有相關工作。
2. Fork 儲存庫並切換到 `dev` 分支。
3. 一個分支只解決一個明確問題。
4. 修改技能時必須使用 `writing-skills` 並執行行為評估。
5. 至少在一個智慧體中測試，並完整揭露智慧體環境。
6. 建立 PR 前，先讓人工審查者查看完整 diff。

專案專用、工具專用和範圍狹窄的個人整合通常應作為獨立外掛發布。完整流程請參閱 [`skills/writing-skills/SKILL.md`](skills/writing-skills/SKILL.md) 和 [`docs/testing.md`](docs/testing.md)。

---

## 社群

- [GitHub Issues](https://github.com/wukongnotnull/wukong-code/issues)
- [原始碼儲存庫](https://github.com/wukongnotnull/wukong-code)

---

## 授權條款

Wukong Code 採用 [MIT 授權條款](LICENSE)。第三方聲明記錄在 [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) 中。

<div align="center">

MIT License · [Wukong Code](https://github.com/wukongnotnull/wukong-code)

</div>
