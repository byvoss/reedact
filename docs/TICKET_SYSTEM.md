# Ticket System Documentation

## Ticket Format: [RXX-YYYY]

### Kategorien (RXX)

| Code | Kategorie | Beschreibung | Typische Phasen |
|------|-----------|--------------|-----------------|
| **R01** | Verwaltungsaufgaben | Admin, Organisation, Prozesse | Meist nur D |
| **R02** | Infrastructure/DevOps | CI/CD, Server, Deployment | P, C, D, T |
| **R03** | ReedACT | Core Framework Development | P, C, D, T |
| **R04** | ReedCMS | CMS Implementation | P, C, D, T |
| **R05** | Extensions | IDE-Plugins (JetBrains, VS Code, etc) | P, C, D |
| **R06** | Security/Compliance | Sicherheit, Audits, Compliance | P, D, T |
| **R07** | Performance/Optimization | Performance, Caching, Optimierung | P, C, T |
| **R08** | Research/Prototypes | Experimente, Prototypen, PoCs | P, C |

### Phasen (Ein Ticket, mehrere Phasen)

| Phase | Bedeutung | Commit Prefix | Deliverable |
|-------|-----------|---------------|-------------|
| **P** | Planning/Design | `feat(planning):` | Design docs, ADRs, [PLAN] file |
| **C** | Code Development | `feat:` oder `fix:` | Working code, unit tests |
| **D** | Dokumentation | `docs:` | Updated docs, examples |
| **T** | Testing | `test:` | Integration tests, benchmarks |

## Workflow

```
1. Ticket erstellen (R03-0001)
2. Phase P: Planning → commit
3. Phase C: Code → commit  
4. Phase D: Docs → commit
5. Phase T: Tests → commit
6. Done → Archive in docs/tickets/done/
```

## Wichtige Regeln

1. **JEDE Phase wird separat committed** - keine Sammlung von Änderungen!
2. **Board.csv immer aktuell halten** - zeigt aktuellen Status aller Tickets
3. **Dependencies tracken** - Welches Ticket wartet auf welches
4. **Nicht alle Phasen sind Pflicht** - R01 Tickets haben oft nur D Phase

## Board.csv Struktur

```csv
ticket_id,current_phase,status,depends_on,title,assigned_to,created,updated,phase_completed
R03-0001,C,active,,"Template Engine",claude,2024-01-26,2024-01-27,"P"
R03-0002,P,blocked,"R03-0001","WebSocket Support",,2024-01-27,2024-01-27,""
```

### Status-Werte
- **backlog**: Noch nicht begonnen
- **active**: In Bearbeitung
- **blocked**: Wartet auf Dependencies
- **review**: In Review (optional)
- **done**: Abgeschlossen

## Beispiel: Neues ReedACT Feature

```bash
# 1. Ticket erstellen
TICKET_ID="R03-0003"
cp docs/tickets/TEMPLATE.md docs/tickets/${TICKET_ID}.md
echo "${TICKET_ID},P,active,,\"Reactive Bindings\",,$(date -u +%Y-%m-%d),$(date -u +%Y-%m-%d),\"\"" >> docs/tickets/board.csv

# 2. Planning Phase
# ... Design work ...
git commit -m "feat(planning): ${TICKET_ID} - Reactive bindings design"
# Update board.csv: P→C, phase_completed="P"

# 3. Code Phase  
git checkout -b feature/${TICKET_ID}
# ... Implementation ...
git commit -m "feat: ${TICKET_ID} - Implement reactive bindings"
# Update board.csv: C→D, phase_completed="P,C"

# 4. Documentation Phase
# ... Write docs ...
git commit -m "docs: ${TICKET_ID} - Reactive bindings documentation"
# Update board.csv: D→T, phase_completed="P,C,D"

# 5. Testing Phase
# ... Write tests ...
git commit -m "test: ${TICKET_ID} - Reactive bindings tests"
# Update board.csv: T→done, phase_completed="P,C,D,T"

# 6. Archivieren
mv docs/tickets/${TICKET_ID}*.md docs/tickets/done/
```

## Quick Commands

```bash
# Aktive Tickets anzeigen
grep ",active," docs/tickets/board.csv | cut -d',' -f1,2,5

# Blocked Tickets anzeigen  
grep ",blocked," docs/tickets/board.csv

# Nächste freie Nummer für Kategorie
CATEGORY="R03"
NEXT=$(grep "^${CATEGORY}-" docs/tickets/board.csv | wc -l | xargs expr 1 +)
echo "${CATEGORY}-$(printf "%04d" $NEXT)"
```