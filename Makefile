all: build run 

build: 
	docker build -t deb-redis:latest .

run:
	docker run -d --name deb-redis -p 6379:6379 deb-redis:latest

clean:
	docker kill deb-redis
	docker rm -f deb-redis