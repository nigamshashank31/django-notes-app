FROM python:3.9

WORKDIR /app/backend

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*
# First copy requirements.txt explicitly to leverage build cache
COPY requirements.txt .

# Now install dependencies 

RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the app code
COPY . /app/backend

EXPOSE 8000
CMD ["sh", "-c", "python manage.py migrate --noinput && gunicorn notesapp.wsgi --bind 0.0.0.0:8000"] 

# Test the Code through github commit
