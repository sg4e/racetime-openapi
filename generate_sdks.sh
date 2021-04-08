#!/bin/sh
if [ ! -f openapi-generator-cli-5.1.0.jar ]; then
  curl https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/5.1.0/openapi-generator-cli-5.1.0.jar -O openapi-generator-cli.jar
fi
mkdir -p sdks

make_sdk () {
  # $1 is language, $2 is stability tag (beta, experimental)
  local d=$1$2
  echo Making $d
  # There does not appear to be any way to make the output of this less verbose:
  java -jar openapi-generator-cli-5.1.0.jar generate -i openapi.yaml -g $1 -o sdks/$d
  zip -r sdks/$d.zip sdks/$d
}

for lang in ada android apex bash c clojure cpp-qt5-client cpp-restsdk cpp-tizen csharp csharp-netcore dart dart-dio dart-jaguar eiffel elixir elm erlang-client erlang-proper go groovy haskell-http-client java javascript javascript-closure-angular javascript-flowtyped jaxrs-cxf-client jmeter kotlin objc ocaml perl php python-legacy r ruby rust scala-akka scala-gatling scalaz typescript-angular typescript-aurelia typescript-axios typescript-fetch typescript-inversify typescript-jquery typescript-node typescript-redux-query typescript-rxjs; do
  make_sdk $lang ""
done

echo Making non-stable sdks
for lang in cpp-ue4 crystal javascript-apollo k6 lua nim powershell scala-sttp swift5; do
  make_sdk $lang "-BETA"
done
for lang in dart-dio-next python typescript typescript-nestjs; do
  make_sdk $lang "-EXPERIMENTAL"
done

echo Making docs
for lang in html html2 markdown; do
  make_sdk $lang "-documentation"
done
