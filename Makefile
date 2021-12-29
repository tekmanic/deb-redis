build: 
	docker build -t deb-redis:latest .

run:
	docker run -d --name deb-redis -p 6379:6379 deb-redis:latest

all: build run 