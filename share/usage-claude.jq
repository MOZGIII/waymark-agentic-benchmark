# Usage of one Claude Code session from its stream-json events (slurped).
# Assistant lines repeat per content block of one response, so responses and
# tool calls are counted by unique id. The result event's usage is the
# authoritative total for the main loop.
def assistants: map(select(.type == "assistant"));
def tool_uses: assistants | map(.message.content[]? | select(.type == "tool_use")) | unique_by(.id);
def result: map(select(.type == "result")) | last;
{
  responses: (assistants | map(.message.id) | unique | length),
  tool_calls: (tool_uses | length),
  tools: (tool_uses | group_by(.name) | map({(.[0].name): length}) | add // {}),
  result: (result | if . == null then null else {
    subtype,
    turns: .num_turns,
    cost_usd: .total_cost_usd,
    tokens: {
      input: .usage.input_tokens,
      output: .usage.output_tokens,
      cache_read: .usage.cache_read_input_tokens,
      cache_creation: .usage.cache_creation_input_tokens
    }
  } end)
}
