# typed: false
# frozen_string_literal: true

# Adept compiler formula
class Adept < Formula
  desc "Blazing fast language for general purpose programming"
  homepage "https://github.com/AdeptLanguage/Adept"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/AdeptLanguage/Adept/archive/v2.7.tar.gz"
    sha256 "74b2bef3e9adddc88ecabc9237d178236fc2e21d342e527cea2e031450bb0899"
    depends_on "llvm@13"

    resource "import" do
      url "https://github.com/AdeptLanguage/AdeptImport/archive/v2.7.tar.gz"
      sha256 "87a02463d283c324c47f552e0569b5cbc74027e7dde557989acb9b334e2115c0"
    end

    # Lazily grab latest configuration
    resource "adept.config" do
      url "https://github.com/AdeptLanguage/Config.git"
    end
  end

  bottle do
    root_url "https://github.com/AdeptLanguage/homebrew-tap/releases/download/adept-2.7"
    sha256 cellar: :any,                 big_sur:      "af57bac4e787516f93e9b31e7ef573638b88f01785a10ab2f05066889266e224"
    sha256 cellar: :any,                 catalina:     "06f55da10ce9d015abd0851130f4c3eed344f842d89dcb4cc6ee94be7e2d49ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ced908d4623da8ec28ed457f46616838deef5334761690f0e81a0a48a7b77d01"
  end

  head do
    url "https://github.com/AdeptLanguage/Adept.git"
    depends_on "llvm@13"

    resource "import" do
      url "https://github.com/AdeptLanguage/AdeptImport.git"
    end

    resource "adept.config" do
      url "https://github.com/AdeptLanguage/Config.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "curl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    libexec.install "adept"
    (libexec/"import").install resource("import")
    libexec.install resource("adept.config")
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
