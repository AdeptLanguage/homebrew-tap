# typed: false
# frozen_string_literal: true

# Adept compiler formula
class Adept < Formula
  desc "Blazing fast language for general purpose programming"
  homepage "https://github.com/AdeptLanguage/Adept"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/AdeptLanguage/Adept/archive/v2.4.tar.gz"
    sha256 "029c83144edd30968acf32291fa334a94c09d1b2676127db00b46e4e55567506"

    resource "import" do
      url "https://github.com/AdeptLanguage/AdeptImport/archive/v2.4.tar.gz"
      sha256 "b2d2d92e7e2ffd7b02b25b9f822f57db161c54ad547f9ac8c1118a3de35c5846"
    end

    # Lazily grab latest configuration
    resource "adept.config" do
      url "https://github.com/AdeptLanguage/Config.git"
    end
  end

  bottle do
    root_url "https://github.com/AdeptLanguage/homebrew-tap/releases/download/adept-2.4"
    sha256 cellar: :any, big_sur:      "af744f4baf1064de1d12c6b7ffa40d1a008f597fd273e2d93758837ff18ae780"
    sha256 cellar: :any, catalina:     "ed73a8ba04c26c174e4286621ed1df1daaf18ad8941c8da98e6210b79faa4733"
    sha256 cellar: :any, x86_64_linux: "3c58317eb2a2b431a1ed827f4260560400ee5678b2799dfe268bac669c6e29f4"
  end

  head do
    url "https://github.com/AdeptLanguage/Adept.git"

    resource "import" do
      url "https://github.com/AdeptLanguage/AdeptImport.git"
    end

    resource "adept.config" do
      url "https://github.com/AdeptLanguage/Config.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "curl"
  depends_on "llvm@9"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    libexec.install "adept"
    (libexec/"import").install resource("import")
    (libexec).install resource("adept.config")
    bin.install_symlink libexec/"adept"
  end

  test do
    (testpath/"test.adept").write <<~EOS
      import basics
      func main {
        print("Hello World!")
      }
    EOS
    system bin/"adept", "test.adept"
    assert_match "Hello World!", shell_output("./test")
  end
end
