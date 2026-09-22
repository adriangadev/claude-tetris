---
description: Clima actual de una ciudad (o de tu ubicación por IP si no pones ciudad)
argument-hint: [ciudad]
allowed-tools: Bash(bash .claude/skills/local-weather/scripts/weather.sh:*)
---

!`bash .claude/skills/local-weather/scripts/weather.sh "$ARGUMENTS" line`

Reporta el resultado de arriba en lenguaje natural, breve.
