# Usage of one Codex session from its JSONL events (slurped). Tokens are
# normalised to the same four kinds as Claude Code: Codex's input count
# includes cached tokens, which are split out as cache reads.
def items: map(select(.type == "item.completed") | .item);
def actions: items | map(select(.type != "agent_message" and .type != "reasoning"));
def turn: map(select(.type == "turn.completed")) | last;
{
  responses: (items | map(select(.type == "agent_message")) | length),
  tool_calls: (actions | length),
  tools: (actions | group_by(.type) | map({(.[0].type): length}) | add // {}),
  result: (turn | if . == null then null else {
    subtype: "turn.completed",
    turns: null,
    cost_usd: null,
    tokens: {
      input: (.usage.input_tokens - (.usage.cached_input_tokens // 0)),
      output: .usage.output_tokens,
      cache_read: (.usage.cached_input_tokens // 0),
      cache_creation: 0
    }
  } end)
}
