
pytest:
	venv/bin/python -m pytest --doctest-modules ./main.py

build:
	DOCKER_BUILDKIT=1 docker build --pull --rm -f "Dockerfile" -t pasaopasen/bcg "."

go:
	docker run -it --rm pasaopasen/bcg sh

run:
	docker run --rm pasaopasen/bcg /bin/sh -c "python main.py data out.txt && cat out.txt"
