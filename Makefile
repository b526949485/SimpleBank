DB_URL=postgresql://ws:123123@localhost:5432/simple_bank?sslmode=disable

postgres:
	docker run --name postgres16.3 -p 5432:5432 -e POSTGRES_USER=ws -e POSTGRES_PASSWORD=123123 -d postgres:16.3-alpine
mysql:
	docker run --name mysql -p 3309:3306 -e MYSQL_USER=ws -e MYSQL_ROOT_PASSWORD=123123 -d mysql:latest
createdb:
	docker exec -it postgres16.3 createdb --username=ws --owner=ws simple_bank
dropdb:
	docker exec -it postgres16.3 dropdb simple_bank
migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up
migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down
sqlc:
	sqlc generate
test:
	go test -v -cover ./...

.PHONY: postgres mysql createdb dropdb migrateup migratedown sqlc test