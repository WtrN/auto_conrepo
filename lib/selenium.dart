import 'dart:convert';
import 'dart:io';
import 'package:conrepo/config.dart';
import 'package:webdriver/sync_io.dart';

// var chromeDriverProcess;

// var driver;

Future startChromeDriverProcess() async {
  print('startChromeDriverProcess: starting ChromeDriverProcess');
  final chromeDriverProcess = await Process.start(
    'chromedriver',
    ['--port=4444', '--url-base=wd/hub', '--verbose'],
  );

  await for (String browserOut in const LineSplitter()
      .bind(utf8.decoder.bind(chromeDriverProcess.stdout))) {
    if (browserOut.contains('Starting ChromeDriver')) {
      print(
          'startChromeDriverProcess: ChromeDriverProcess succesfully started');
      print(browserOut);
      break;
    }
  }
}

Future _launchChrome() async {
  print('BrowserHandler._launchChrome: initializing ChromeDriver');

  final driver = await createDriver(
      spec: WebDriverSpec.JsonWire,
      desired: Capabilities.chrome); //this the point where the test gets stuck_
  print('BrowserHandler._launchChrome: ChromeDriver initialized');
  print('BrowserHandler._launchChrome: loaded');
  return driver;
}

Future<void> _openAndLogin(driver) async {
  await driver.get(targetUrl);

  final WebElement userId = await driver.findElement(const By.id('__BVID__15'));
  await userId.sendKeys(userName);

  final WebElement password =
      await driver.findElement(const By.id('__BVID__18'));
  await password.sendKeys(userPassword);

  final WebElement loginButton =
      await driver.findElement(const By.className('btn'));
  await loginButton.click();
}

Future _conditionInput(driver) async {
  final WebElement temparature =
      await driver.findElement(const By.name('custom-control-label'));
  print(temparature.name);
  await temparature.click();

  final WebElement condition =
      await driver.findElement(const By.linkText('問題なし'));
  await condition.click();

  final WebElement working = await driver.findElement(const By.linkText('勤務'));
  await working.click();

  final WebElement place = await driver.findElement(const By.linkText('在宅'));
  await place.click();
}

void main() async {
  await startChromeDriverProcess();
  final driver = await _launchChrome();
  await _openAndLogin(driver);
  // await _conditionInput(driver);
}
