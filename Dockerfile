FROM python:alpine as release

# Install component
RUN apk add --no-cache wget gcompat

WORKDIR /app

EXPOSE 80

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

ENTRYPOINT [ "python", "app.py" ]
