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
    sha256 cellar: :any,                 big_sur:      "4dbfcceb6c7cef0b3807716f6714ccbd90fa30c76385cec8c60355e18645dd61"
    sha256 cellar: :any,                 catalina:     "8b7722dc40d4d4326798591b38d76c45a202a2e27c3eb021462f56d9990aa297"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c4f63829296592b218f9862ce8c00eea34308bf241adb99064c9b2552c7c251a"
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
