FROM python:3.12-slim AS test
WORKDIR /app
COPY app.py test_app.py ./
RUN python -m unittest -v

FROM python:3.12-slim
WORKDIR /app
RUN useradd --create-home appuser
COPY --from=test /app/app.py .
ARG APP_VERSION=dev
ENV APP_VERSION=$APP_VERSION
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=10s --timeout=3s CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"
CMD ["python", "app.py"]
