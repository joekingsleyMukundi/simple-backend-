postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=mysecret -d postgres:15.2-alpine

startpostgres:
	docker start postgres15

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:mysecret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:mysecret@localhost:5432/simple_bank?sslmode=disable" -verbose down
	
sqlc:
	./sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go
.PHONY: postgres startpostgres createdb dropdb migrateup migratedown sqlc test server