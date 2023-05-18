# Stage 1 - Install dependencies and build the app
FROM debian:latest AS build-env

# Install flutter dependencies
RUN apt-get update && \
    apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 psmisc && \
    apt-get clean

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable flutter web
RUN flutter channel master && \
    flutter upgrade && \
    flutter config --enable-web

# Copy the pubspec files and get dependencies
COPY pubspec.* /usr/local/bin/app/
WORKDIR /usr/local/bin/app
RUN flutter pub get

# Copy the rest of the app files
COPY . /usr/local/bin/app

RUN flutter build web --web-renderer canvaskit --release

# Stage 2 - Build the image
FROM nginx:alpine
COPY --from=build-env /usr/local/bin/app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]