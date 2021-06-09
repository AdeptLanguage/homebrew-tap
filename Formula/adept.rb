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
  end

  bottle do
    root_url "https://github.com/AdeptLanguage/homebrew-tap/releases/download/adept-2.4"
    cellar :any
    sha256 "af744f4baf1064de1d12c6b7ffa40d1a008f597fd273e2d93758837ff18ae780" => :big_sur
    sha256 "ed73a8ba04c26c174e4286621ed1df1daaf18ad8941c8da98e6210b79faa4733" => :catalina
    sha256 "3c58317eb2a2b431a1ed827f4260560400ee5678b2799dfe268bac669c6e29f4" => :x86_64_linux
  end

  head do
    url "https://github.com/AdeptLanguage/Adept.git"

    resource "import" do
      url "https://github.com/AdeptLanguage/AdeptImport.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "llvm@9"
  depends_on "curl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    libexec.install "adept"
    (libexec/"import").install resource("import")
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
