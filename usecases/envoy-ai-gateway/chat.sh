curl -X POST http://192.168.1.220/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "x-ai-eg-model: qwen3-2507-4b" \
    -d '{
      "model": "qwen3-2507-4b",
      "messages": [
        {
          "role": "user",
          "content": "Hello, how are you?"
        }
      ],
      "max_tokens": 150,
      "temperature": 0.7
    }' | jq
