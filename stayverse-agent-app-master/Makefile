.PHONY: clean refresh build-runner build-adb build-apk clean-ios clean-build-runner refresh-env open-xcode refresh-lang run-dev prod-test production development env-prod env-dev 

refresh:
	@echo "╠ Getting Dependency"
	fvm flutter pub get 

clean-ios:
	@echo "╠ Cleaning ios the code"
	fvm flutter clean
	cd ios && rm -rf Podfile.lock 
	cd ios && rm -rf Pods 
	fvm flutter pub get
	cd ios && pod install

build-adb:
	@echo "╠ Getting Dependency"
	fvm flutter pub get
	fvm flutter build appbundle 

build-apk:refresh
	@echo "╠ Building apk"
	@fvm flutter build apk --split-per-abi	


env-prod:production clean-build-runner refresh

env-dev:development clean-build-runner refresh

production:
	sed -i '' 's/mode=.*/mode=prod/' .env

development:
	sed -i '' 's/mode=.*/mode=dev/' .env

build-runner:
	@echo "╠ Build Runner Started"
	@fvm flutter pub run build_runner build

clean-build-runner:
	@echo "╠ Cleaning Build Runner"
	@fvm flutter pub run build_runner clean
	@fvm flutter pub run build_runner build --delete-conflicting-outputs

clean:
	@echo "╠ Cleaning Flutter"
	@fvm flutter clean
	@fvm flutter pub get

refresh-env: build-runner	

open-xcode:
	open ios/Runner.xcworkspace

refresh-lang:
	@echo "╠ Rereshing String language"
	fvm flutter gen-l10n

run-dev:
	fvm flutter run --dart-define=env.mode=dev

prod-test:
	@echo "╠ Running production test"
	fvm flutter test /Users/mines/AndroidStudioProjects/zylag/test/core/prod_test.dart	
