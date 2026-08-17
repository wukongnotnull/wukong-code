# Wukong Code

<p align="center">
  <img src="./assets/readme/hero.png" width="100%" alt="Wukong Code: 코딩 에이전트를 위한 완전한 소프트웨어 개발 방법론. 설계 우선, TDD, 주장보다 검증.">
</p>

**코딩 에이전트를 위한 완전한 소프트웨어 개발 방법론**

설계 우선 · 테스트 주도 개발 · 주장보다 검증

[라이선스: MIT](LICENSE)
[버전](https://github.com/wukongnotnull/wukong-code/tags)
[플러그인](https://github.com/wukongnotnull/wukong-code)
[Stars](https://github.com/wukongnotnull/wukong-code/stargazers)

**언어:** [English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md)

> Wukong Code는 조합 가능한 스킬과 각 스킬을 적절한 순간에 자동으로 활성화하는 시작 지침을 코딩 에이전트에 제공합니다. 브레인스토밍과 계획부터 TDD, 리뷰, 검증까지 하나의 흐름으로 연결합니다.

<p align="center">
  <img src="./assets/readme/workflow.svg" width="100%" alt="개발 경로: 아이디어, 설계, 계획, RED, GREEN, 이후 리뷰와 검증.">
</p>

---

**빠른 탐색**

[Wukong Code를 선택하는 이유](#wukong-code를-선택하는-이유) · [작동 방식](#작동-방식) · [설치](#지원-에이전트와-설치) · [기본 워크플로](#기본-워크플로) · [스킬](#포함된-내용) · [언어 가이드](#언어-가이드) · [FAQ](#faq) · [기여](#기여) · [라이선스](#라이선스)

---

## Wukong Code를 선택하는 이유

| 기능 | 얻을 수 있는 것 |
| --- | --- |
| **코드보다 설계 우선** | 에이전트가 목표를 명확히 하고 대안을 비교하며 승인을 받은 뒤 구현합니다 |
| **실행 가능한 계획** | 승인된 설계를 정확한 파일과 검증 단계가 있는 작은 작업으로 나눕니다 |
| **진정한 TDD** | 구현 후 테스트를 추가하는 대신 RED–GREEN–REFACTOR를 강제합니다 |
| **체계적인 디버깅** | 수정안을 제시하기 전에 근본 원인을 조사합니다 |
| **과정 내 리뷰** | 진행 중에 명세 준수와 코드 품질을 계속 확인합니다 |
| **주장보다 검증** | 추측이 아니라 최신 검증 결과를 바탕으로 완료를 선언합니다 |
| **자동 활성화** | 작업 맥락에 따라 스킬이 활성화되며 작업마다 특별한 프롬프트를 입력할 필요가 없습니다 |

코드를 빠르게 생성하는 것에 그치지 않고, 코딩 에이전트가 반복 가능한 엔지니어링 절차를 따르기를 원하는 개발자를 위한 도구입니다.

---

## 작동 방식

Wukong Code는 에이전트 세션이 시작될 때부터 동작합니다. 요청을 알맞은 소프트웨어 개발 또는 Product Design 워크플로로 연결한 뒤, 현재 작업에 필요한 전문 스킬만 불러옵니다.

### 소프트웨어 개발

빌드나 동작 변경 요청을 감지하면 바로 코드를 작성하지 않고, 먼저 실제로 달성하려는 목표를 구체화합니다.

설계가 승인되면 구체적인 구현 계획을 작성하고 올바른 Red/Green TDD를 따릅니다. 필요할 때 독립 작업을 위임하고 결과를 리뷰하며, 전체 변경을 검증한 뒤에만 완료를 선언합니다.

```text
아이디어
   ↓
브레인스토밍 → 승인된 설계 → 구현 계획
   ↓
RED → GREEN → REFACTOR → 리뷰 → 검증
   ↓
병합 / PR 생성 / 브랜치 유지
```

### Product Design

Product Design은 제품 아이디어와 작동하는 소프트웨어 사이의 간격을 줄입니다. 저장된 제품 정보가 있다면 브랜드 자산, 디자인 시스템, 스크린샷, 컴포넌트, 선호 도구를 설계 근거로 사용하고 목표에 맞는 경로를 선택합니다.

```text
리서치 또는 감사
제품 / 흐름 → 현재 근거 캡처 → UX, 시각 디자인, 접근성 제안

새 방향 탐색
디자인 브리프 → 3개의 시각 옵션 → 사용자 선택 → 반응형 프로토타입

복제 또는 구현
라이브 URL 또는 선택한 시각 자료 → 프런트엔드 구현 → Design QA → 미리보기 / 공유
```

리서치와 감사는 현재 수집한 근거에 기반하며 소스 코드를 변경하지 않습니다. 새 디자인은 시각 방향을 선택한 뒤에만 구현으로 진행합니다. 프로토타입은 렌더링 결과를 시각 원본과 비교하고 Design QA를 통과해야 전달할 수 있습니다.

스킬은 자동으로 활성화됩니다. 평소처럼 코딩 에이전트와 대화하면 소프트웨어 개발과 Product Design 절차가 세션 안에서 실행되며, 실제로 사용할 수 있는 브라우저, 이미지 생성, 로컬 빌드, 공유 기능에 맞게 실행 방식을 조정합니다.

---

## 지원 에이전트와 설치

설치 방법은 에이전트마다 다릅니다. 여러 에이전트를 사용한다면 각각 Wukong Code를 설치해야 합니다.

**지원:** [Antigravity](#antigravity) · [Claude Code](#claude-code) · [Codex App](#codex-app) · [Codex CLI](#codex-cli) · [Cursor](#cursor) · [Factory Droid](#factory-droid) · [GitHub Copilot CLI](#github-copilot-cli) · [Kimi Code](#kimi-code) · [OpenCode](#opencode) · [Pi](#pi)

### Antigravity

이 저장소에서 플러그인을 설치합니다.

```bash
agy plugin install https://github.com/wukongnotnull/wukong-code
```

Antigravity는 세션 시작 훅을 실행하므로 첫 메시지부터 Wukong Code가 활성화됩니다. 업데이트하려면 같은 명령을 다시 실행하세요.

### Claude Code

이 저장소에서 설치합니다.

```bash
/plugin marketplace add wukongnotnull/wukong-code
/plugin install wukong-code@wukong-code
```

### Codex App

Wukong Code는 Codex 공식 플러그인 마켓플레이스에 등록되어 있지 않습니다. 이 저장소 URL에서 직접 설치하세요.

1. Codex 사이드바에서 **Plugins**를 클릭합니다.
2. 저장소 URL에서 플러그인을 설치하는 옵션을 선택합니다.
3. `https://github.com/wukongnotnull/wukong-code`를 입력하고 안내를 따릅니다.

### Codex CLI

이 저장소를 마켓플레이스 소스로 추가한 다음 Wukong Code를 설치합니다.

```bash
/plugin marketplace add wukongnotnull/wukong-code
/plugin install wukong-code@wukong-code
```

### Cursor

Cursor Agent 채팅에서 다음을 입력합니다.

```text
/add-plugin wukong-code
```

또는 플러그인 마켓플레이스에서 `wukong-code`를 검색합니다.

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

`/plugins`를 열고 **Marketplace → Wukong Code**에서 설치합니다. 저장소에서 직접 설치할 수도 있습니다.

```text
/plugins install https://github.com/wukongnotnull/wukong-code
```

자세한 내용은 [Kimi Code 설치 가이드](docs/README.kimi.md)를 참고하세요.

### OpenCode

OpenCode에 다음과 같이 요청합니다.

```text
Fetch and follow instructions from https://raw.githubusercontent.com/wukongnotnull/wukong-code/refs/heads/main/.opencode/INSTALL.md
```

자세한 내용은 [OpenCode 설치 가이드](docs/README.opencode.md)를 참고하세요.

### Pi

Pi 패키지로 설치합니다.

```bash
pi install git:github.com/wukongnotnull/wukong-code
```

로컬 개발에서는 다음을 실행합니다.

```bash
pi -e /path/to/wukong-code
```

Pi 패키지는 스킬을 불러오고 시작 시점과 컨텍스트 압축 후에 `using-wukong-code` 부트스트랩을 주입합니다. Pi는 스킬을 기본 지원하며, 서브에이전트와 작업 목록 도구는 선택적인 보조 패키지입니다.

---

## 기본 워크플로

### 소프트웨어 개발 워크플로

1. **using-wukong-code** — 어떤 행동을 하기 전에 작업을 확인하고 적용 가능한 가장 작은 워크플로를 선택합니다.
2. **brainstorming**, **systematic-debugging** 또는 직접 처리 — 새 기능은 설계부터, 원인이 불분명한 버그는 근본 원인 조사부터 시작하며, 명확한 기계적 변경은 바로 처리합니다.
3. **writing-plans** — 승인된 다단계 설계를 정확한 파일 경로와 검증 단계가 있는 작은 작업으로 나눕니다.
4. **using-git-worktrees** — 실행에 격리가 필요할 때 독립 작업 공간을 만들고 깨끗한 테스트 기준선을 확인합니다.
5. **subagent-driven-development** 또는 **executing-plans** — 작업 단위 리뷰나 사람의 체크포인트와 함께 계획을 실행하며, TDD가 적용될 때 RED–GREEN–REFACTOR를 따릅니다.
6. **verification-before-completion**과 코드 리뷰 — 완료를 주장하기 전에 최신 근거를 확보하고 전체 결과를 확인합니다.
7. **finishing-a-development-branch** — 이미 정해진 통합 의도를 따르며, 아직 결정되지 않았다면 병합, PR, 유지, 폐기 옵션을 제공합니다.

**에이전트는 모든 작업 전에 관련 스킬을 확인합니다. 이 워크플로는 권장 사항이 아니라 필수 요건입니다.**

### Product Design 워크플로

1. **product-design** — 목표를 파악하고 요청을 알맞은 Product Design 전문 스킬로 연결합니다.
2. **product-design-user-context** — 현재 작업의 근거가 될 때 저장된 브랜드 자산, 디자인 시스템, 스크린샷, 참고 자료, 선호 설정을 불러옵니다.
3. **product-design-context** — 시각 탐색이나 구현 전에 디자인 대상, 목표 사용자, 기대 결과를 명확히 합니다.
4. **product-design-research**, **product-design-audit** 또는 **product-design-ideate** — 현재 사용자 문제를 조사하고, 수집한 제품 근거를 감사하거나, 선택할 수 있는 세 가지 시각 방향을 생성합니다.
5. **product-design-url-to-code** 또는 **product-design-image-to-code** — 라이브 URL을 충실히 재현하거나 선택한 시각 자료를 반응형 프런트엔드로 구현합니다.
6. **product-design-design-qa** — 렌더링한 프로토타입과 시각 원본을 비교하고, 통과할 때까지 전달을 막습니다.
7. **product-design-share** — 사용자가 배포나 공유를 요청하면 실행 가능한 프로토타입을 게시하고 공유 링크를 반환합니다.

**이 스킬들이 모든 요청에서 하나의 고정 순서로 전부 실행되는 것은 아닙니다. Product Design은 리서치, 감사, 아이디어 탐색, 복제, 구현, QA, 공유 목표에 따라 적용 가능한 가장 짧은 경로를 선택합니다.**

---

## 포함된 내용

**26개의 최상위 스킬**: 범용 개발 스킬 16개와 Product Design 스킬 10개.

| 영역 | 스킬과 가이드 |
| --- | --- |
| **테스트** | `test-driven-development`, 테스트 안티패턴 |
| **디버깅** | `systematic-debugging`, 근본 원인 추적, 심층 방어, 조건 기반 대기 |
| **검증** | `verification-before-completion` |
| **계획** | `brainstorming`, `grilling`, `writing-plans`, `executing-plans` |
| **협업** | `dispatching-parallel-agents`, `subagent-driven-development`, `requesting-code-review`, `receiving-code-review` |
| **작업 공간** | `using-git-worktrees`, `finishing-a-development-branch` |
| **언어 구현** | 실험적이며 근거 기반인 `language-guidance` 팩 |
| **메타** | `writing-skills`, `using-wukong-code` |

### Product Design

다음 10개의 Product Design 스킬이 포함됩니다.

| 스킬 | 역할 |
| --- | --- |
| `product-design` | Product Design의 진입점으로서 목표에 맞는 전문 워크플로로 연결합니다 |
| `product-design-user-context` | 브랜드 자산, 디자인 시스템, 스크린샷, 참고 자료, 선호 설정을 저장하거나 불러옵니다 |
| `product-design-context` | 디자인 대상, 목표 사용자, 기대 결과를 명확히 합니다 |
| `product-design-research` | 최신 출처를 바탕으로 사용자 문제와 제품 기회를 조사합니다 |
| `product-design-audit` | 현재 수집한 근거로 제품 흐름의 UX, 시각 디자인, 접근성 문제를 감사합니다 |
| `product-design-ideate` | 구체적인 주제에 기반하고 의도적인 시각 선택과 안티 템플릿 비평을 포함한 세 가지 독창적 방향을 생성합니다 |
| `product-design-url-to-code` | 라이브 URL을 실행 가능한 로컬 프런트엔드 프로토타입으로 충실히 재현합니다 |
| `product-design-image-to-code` | 선택한 시각 자료를 반응형 인터랙티브 프런트엔드로 구현합니다 |
| `product-design-design-qa` | 시각 원본과 렌더링 결과를 비교하고 전달 가능 여부를 판정합니다 |
| `product-design-share` | 요청 시 실행 가능한 프로토타입을 게시하고 공유 링크를 반환합니다 |

---

## 언어 가이드

Wukong Code의 방법론은 특정 언어에 종속되지 않습니다. 저장소 근거로 지원 언어와 작업 단계를 확인할 수 있을 때만 에이전트가 필요한 구현 가이드를 불러옵니다. 언어 팩은 도구를 설치하거나 저장소 명령을 덮어쓰지 않습니다.

| 언어 | 상태 | 구현 | 테스트 | 디버깅 | 리뷰 | 검증 | 근거 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Go | 실험적 | ✓ | ✓ | ✓ | ✓ | ✓ | [평가 보고서](docs/wukong-code/evals/2026-07-22-go-language-guidance.md) |
| Java | 실험적 | ✓ | ✓ | ✓ | ✓ | ✓ | [평가 보고서](docs/wukong-code/evals/2026-08-02-java-language-guidance.md) |
| TypeScript | 계획됨 | — | — | — | — | — | — |
| JavaScript | 계획됨 | — | — | — | — | — | — |
| Swift | 실험적 | ✓ | ✓ | ✓ | ✓ | ✓ | [평가 보고서](docs/wukong-code/evals/2026-07-29-swift-language-guidance.md) |
| Rust | 실험적 | ✓ | ✓ | ✓ | ✓ | ✓ | [평가 보고서](docs/wukong-code/evals/2026-07-29-rust-language-guidance.md) |

**실험적**은 초기 행동 평가가 존재하지만 실제 프로젝트 근거를 계속 축적하고 있다는 뜻입니다. 프레임워크, 클라우드 서비스, 데이터베이스, 팀별 가이드는 코어 범위에 포함되지 않습니다.

---

## 철학

| 원칙 | 의미 |
| --- | --- |
| **테스트 주도 개발** | 실패하는 테스트를 먼저 작성합니다 |
| **임기응변보다 체계** | 추측 대신 반복 가능한 절차를 따릅니다 |
| **복잡성 감소** | 가장 작고 명확한 해결책을 우선합니다 |
| **주장보다 근거** | 성공을 선언하기 전에 검증합니다 |

---

## FAQ

**스킬을 직접 호출해야 하나요?**

아니요. 올바르게 통합된 에이전트는 세션 시작 시 부트스트랩을 불러오고 작업 맥락에서 관련 스킬을 선택합니다.

**여러 코딩 에이전트에 설치할 수 있나요?**

예. 플러그인 시스템은 서로 독립적이므로 각 에이전트에 따로 설치해야 합니다.

**어떻게 업데이트하나요?**

각 에이전트가 제공하는 업데이트 절차를 사용하세요. 저장소 기반 설치는 일반적으로 설치 명령을 다시 실행해 갱신할 수 있습니다.

**Wukong Code가 프로젝트 의존성을 설치하나요?**

아니요. 코어는 외부 의존성이 없으며 언어 팩도 도구를 설치하거나 저장소가 정의한 명령을 바꾸지 않습니다.

**행동 평가는 어디에 있나요?**

스킬 행동 평가는 [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals)에 있으며 로컬에서는 `evals/`에 클론합니다. 플러그인 인프라 테스트는 `tests/`에 있습니다.

---

## 저자 소개

**悟空非空也 (Wukong)** — Way to AI 창립자, 인디 개발자, 콘텐츠 크리에이터.

| 플랫폼 | 링크 |
| --- | --- |
| 🌐 웹사이트 | [waytoai.cn](https://waytoai.cn) |
| 𝕏 Twitter | [悟空非空也](https://x.com/wukongnotnull) |
| 📺 Bilibili | [悟空非空也](https://space.bilibili.com/456634391) |
| ▶️ YouTube | [悟空非空也](https://www.youtube.com/@wukongnotnull) |
| 📕 Xiaohongshu | [悟空非空也](https://www.xiaohongshu.com/user/profile/5ca89c2f000000001100952b) |
| 💬 WeChat | 「悟空非空也」 검색 |

---

## 감사의 말

영감과 기반을 제공한 다음 오픈 소스 프로젝트 및 스킬 모음에 감사드립니다.

- [Superpowers](https://github.com/obra/superpowers)
- [Frontend Design](https://github.com/anthropics/skills/tree/main/skills/frontend-design)
- [Product Design](https://github.com/openai/role-specific-plugins/tree/main/plugins/product-design)

---

## 라이선스

Wukong Code는 [MIT License](LICENSE)로 배포됩니다. 서드파티 고지는 [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md)에 기록되어 있습니다.

MIT License © [悟空非空也](https://github.com/wukongnotnull)
