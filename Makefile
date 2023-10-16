
TIME:=$(shell date +"%Y-%m-%d-%H-%M")


pytest:
	venv/bin/python -m pytest --doctest-modules ./main.py

build:
	DOCKER_BUILDKIT=1 docker build --pull --rm -f "Dockerfile" -t bcg "."

go:
	docker run -it --rm bcg sh

run:
	docker run --rm bcg /bin/sh -c "python main.py data out.txt && cat out.txt"

#
# necessary to update version in separate command cuz make runs all shells on running file, not running current line
#
v:          ##@Export create version file
	echo -n $(TIME) > version.txt

push: v
	docker tag bcg pasaopasen/bcg:latest
	docker push pasaopasen/bcg:latest
	docker tag bcg pasaopasen/bcg:$(shell cat version.txt)
	docker push pasaopasen/bcg:$(shell cat version.txt)

