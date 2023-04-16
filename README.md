# Stanford_Concentration
Stanford University Course Concentration App


Build basic app:
xcodebuild -scheme Concentration -destination 'platform=iOS Simulator,name=iPhone 14 Pro' -derivedDataPath .

Build app for testing:
xcodebuild build-for-testing -scheme ConcentrationUITests -destination 'platform=iOS Simulator,name=iPhone 14 Pro' -derivedDataPath .

Run xctestrun after build for testing:
xcodebuild test-without-building -xctestrun ConcentrationUITests_iphonesimulator16.2-x86_64.xctestrun -destination 'platform=iOS Simulator,name=iPhone 14 Pro' -only-testing:ConcentrationUITests/PerformanceTests/testCustomScenario

Build and run test:
xcodebuild test -scheme ConcentrationUITests -destination 'platform=iOS Simulator,name=iPhone 14 Pro' -only-testing:ConcentrationUITests/PerformanceTests/testCustomScenario
