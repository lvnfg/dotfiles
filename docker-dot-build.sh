path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$path"

bash "$path/docker-dot.sh" build
