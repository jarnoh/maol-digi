
# maol-digi

This extracts full MAOL formula book from digbi image.

```
docker build -t maol-digi .
docker run --rm -p 8080:80 --name maol-digi -d maol-digi
```

Next, open http://127.0.0.1:8080/
