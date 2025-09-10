@echo off
setlocal enabledelayedexpansion

REM Usage:
REM   init_ai_site.cmd          -> create structure; skip existing files
REM   init_ai_site.cmd force    -> overwrite existing files

set "FORCE=0"
if /I "%1"=="force" set "FORCE=1"

echo.
echo === AI Learning Journey: MkDocs Scaffolder (Windows CMD) ===
echo Force mode: %FORCE%
echo.

REM -----------------------------
REM 1) Create folders
REM -----------------------------
for %%D in (
  docs
  docs\basics
  docs\prompting
  docs\transformers
  docs\llms
  docs\agents
  docs\multi-agents
  docs\showcase
) do (
  if not exist "%%D" (
    mkdir "%%D"
    echo [created] %%D
  ) else (
    echo [exists ] %%D
  )
)

REM Helper: write a one-line file safely (skip unless FORCE=1)
REM %1 = filepath, %2 = content (single line)
:write_one
if "%~1"=="" goto :eof
set "TARGET=%~1"
set "CONTENT=%~2"
if "%FORCE%"=="1" (
  > "%TARGET%" echo %CONTENT%
  echo [wrote  ] %TARGET%
) else (
  if not exist "%TARGET%" (
    > "%TARGET%" echo %CONTENT%
    echo [wrote  ] %TARGET%
  ) else (
    echo [skip  ] %TARGET%
  )
)
goto :eof

REM -----------------------------
REM 2) Section index pages
REM -----------------------------
call :write_one "docs\index.md" "# Welcome`r`n"
call :write_one "docs\basics\index.md" "# Basics"
call :write_one "docs\prompting\index.md" "# Prompting"
call :write_one "docs\transformers\index.md" "# Transformers"
call :write_one "docs\llms\index.md" "# LLMs"
call :write_one "docs\agents\index.md" "# Agents"
call :write_one "docs\multi-agents\index.md" "# Multi-Agents"
call :write_one "docs\showcase\index.md" "# Showcase"
call :write_one "docs\resources.md" "# Resources"
call :write_one "docs\faq.md" "# FAQ"
call :write_one "docs\glossary.md" "# Glossary"

REM -----------------------------
REM 3) Topic stubs
REM -----------------------------
call :write_one "docs\basics\foundations.md" "# Foundations"
call :write_one "docs\basics\embeddings.md" "# Vectors & Embeddings"
call :write_one "docs\basics\tokenization.md" "# Tokenization"

call :write_one "docs\prompting\techniques.md" "# Techniques"
call :write_one "docs\prompting\examples.md" "# Examples"
call :write_one "docs\prompting\antipatterns.md" "# Anti-patterns"

call :write_one "docs\transformers\attention.md" "# Attention"
call :write_one "docs\transformers\fine-tuning.md" "# Training & Fine-tuning"

call :write_one "docs\llms\open-models.md" "# Open Models"
call :write_one "docs\llms\hosted.md" "# Hosted APIs"

call :write_one "docs\agents\tools.md" "# Tools/Functions"
call :write_one "docs\agents\memory.md" "# Memory"

call :write_one "docs\multi-agents\patterns.md" "# Patterns"
call :write_one "docs\multi-agents\cases.md" "# Case Studies"

call :write_one "docs\showcase\mini-projects.md" "# Mini Projects"

REM -----------------------------
REM 4) mkdocs.yml (multi-line)
REM     - overwrite only in FORCE mode
REM -----------------------------
set "YAML=mkdocs.yml"
if "%FORCE%"=="1" del "%YAML%" 2>nul

if not exist "%YAML%" (
  (
    echo site_name: "AI Learning Journey"
    echo site_description: "Notes, code, and examples from my 5-day AI learning plan"
    echo theme:
    echo^  name: material
    echo^  features:
    echo^    - navigation.sections
    echo^    - navigation.instant
    echo^    - navigation.tabs
    echo^    - content.code.copy
    echo^    - search.suggest
    echo^    - search.share
    echo^    - toc.integrate
    echo plugins:
    echo^  - search
    echo markdown_extensions:
    echo^  - admonition
    echo^  - pymdownx.details
    echo^  - pymdownx.superfences
    echo^  - pymdownx.highlight
    echo^  - pymdownx.inlinehilite
    echo^  - pymdownx.tabbed
    echo nav:
    echo^  - Home: index.md
    echo^  - Basics:
    echo^      - basics/index.md
    echo^      - Foundations: basics/foundations.md
    echo^      - Vectors ^& Embeddings: basics/embeddings.md
    echo^      - Tokenization: basics/tokenization.md
    echo^  - Prompting:
    echo^      - prompting/index.md
    echo^      - Techniques: prompting/techniques.md
    echo^      - Examples: prompting/examples.md
    echo^      - Anti-patterns: prompting/antipatterns.md
    echo^  - Transformers:
    echo^      - transformers/index.md
    echo^      - Attention: transformers/attention.md
    echo^      - Training ^& Fine-tuning: transformers/fine-tuning.md
    echo^  - LLMs:
    echo^      - llms/index.md
    echo^      - Open Models: llms/open-models.md
    echo^      - Hosted APIs: llms/hosted.md
    echo^  - Agents:
    echo^      - agents/index.md
    echo^      - Tools/Functions: agents/tools.md
    echo^      - Memory: agents/memory.md
    echo^  - Multi-Agents:
    echo^      - multi-agents/index.md
    echo^      - Patterns: multi-agents/patterns.md
    echo^      - Case Studies: multi-agents/cases.md
    echo^  - Showcase:
    echo^      - showcase/index.md
    echo^      - Mini Projects: showcase/mini-projects.md
    echo^  - Resources: resources.md
    echo^  - FAQ: faq.md
    echo^  - Glossary: glossary.md
  )> "%YAML%"
  echo [wrote  ] %YAML%
) else (
  echo [skip  ] %YAML%
)

echo.
echo Done. Next:
echo   1^) mkdocs serve
echo   2^) mkdocs gh-deploy --clean
echo.

endlocal
