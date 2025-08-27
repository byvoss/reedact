#!/bin/bash
# Pre-Commit Quality Check Script - Mit Phasen-Check

echo "🔍 Running Pre-Commit Quality Checks..."

# 0. Phase Transition Check
echo ""
echo "=== PHASE TRANSITION CHECK ==="
echo "Nach jeder Phasen-Fertigstellung MUSS committed werden!"
echo "Aktuelle Tickets in Arbeit:"
grep -E "^R[0-9]{2}-[0-9]{4}," docs/tickets/board.csv 2>/dev/null | grep ",active," | cut -d',' -f1,2,5 | head -5
echo ""
echo "Welche Phase hast du gerade abgeschlossen?"
echo "  P = Planning abgeschlossen → commit mit 'feat(planning): ...'"
echo "  C = Code fertig → commit mit 'feat: ...' oder 'fix: ...'"  
echo "  D = Dokumentation fertig → commit mit 'docs: ...'"
echo "  T = Tests fertig → commit mit 'test: ...'"
echo ""

# 1. Decision Check
echo ""
echo "=== DECISION CHECK ==="
echo "Recent decisions:"
tail -3 docs/decisions/decisions.csv

# Check if Cargo.toml was modified (new dependencies = decision needed)
if git diff --cached --name-only | grep -q "Cargo.toml"; then
    echo "⚠️  WARNING: Cargo.toml modified - did you log the decision?"
    if ! git diff --cached docs/decisions/decisions.csv | grep -q "+DEC"; then
        echo "❌ ERROR: Cargo.toml changed but no decision logged!"
        echo "Add entry to docs/decisions/decisions.csv before committing!"
        exit 1
    fi
fi

# Check for new patterns
if git diff --cached src/ | grep -q "impl.*for\|trait\|macro_rules"; then
    echo "⚠️  WARNING: New pattern detected - did you log the decision?"
fi

# 2. Code Style
echo ""
echo "=== STYLE CHECK ==="
if ! cargo fmt --check; then
    echo "❌ ERROR: Code not formatted! Run: cargo fmt"
    exit 1
fi

if ! cargo clippy -- -D warnings 2>/dev/null; then
    echo "❌ ERROR: Clippy warnings found!"
    exit 1
fi

# 3. Tests
echo ""
echo "=== TEST CHECK ==="
if ! cargo test --quiet; then
    echo "❌ ERROR: Tests failing!"
    exit 1
fi

# 4. Ticket Reference
echo ""
echo "=== COMMIT MESSAGE CHECK ==="
if [ -z "$SKIP_TICKET_CHECK" ]; then
    echo "Make sure your commit message includes ticket reference (#XXX)"
fi

# 5. Pattern Consistency
echo ""
echo "=== PATTERN CHECK ==="
echo "Did you check similar existing code? (grep -r 'pattern' src/)"
echo "Your code should match existing patterns!"
echo "See docs/STYLE_GUIDE.md for pattern guidelines"

echo ""
echo "✅ Pre-commit checks complete!"
echo ""
echo "Final checklist:"
echo "[ ] Phase completed and board.csv updated"
echo "[ ] Decisions logged if needed"
echo "[ ] Code matches existing patterns"
echo "[ ] Tests pass"
echo "[ ] Commit message has ticket reference (RXX-YYYY)"

# Board Update Reminder
echo ""
echo "=== BOARD UPDATE REMINDER ==="
echo "Vergiss nicht die board.csv zu aktualisieren:"
echo "  1. Current phase auf nächste Phase setzen"
echo "  2. Phase_completed um abgeschlossene Phase ergänzen"
echo "  3. Bei 'done' → Ticket in docs/tickets/done/ verschieben"

exit 0