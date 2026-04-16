#!/bin/bash

echo "Starting Stayverse Platform..."

echo "Starting Backend..."
cd stayverse-backend-main
npm install
npm run start:dev &
cd ..

echo "Starting Admin Portal..."
cd stayverse-admin-main
npm install
npm run dev &
cd ..

echo "Starting Website..."
cd stayverse-website-main
npm install
npm run dev &
cd ..

echo "Starting Agent App..."
cd stayverse-agent-app-master
flutter run &
cd ..

echo "Starting User App..."
cd stayverse-user-app-master
flutter run &
cd ..

echo "All services starting..."
