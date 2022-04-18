# typed: false
# frozen_string_literal: true

# Adept compiler formula
class Adept < Formula
  desc "Blazing fast language for general purpose programming"
  homepage "https://github.com/AdeptLanguage/Adept"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/AdeptLanguage/Adept/archive/v2.6.tar.gz"
    sha256 "e1ff2e9efe20b07a2dc269742fea672b277675d127e578c8e5c107b4c12886ca"
    depends_on "llvm@13"

    resource "import" do
      url "https://github.com/AdeptLanguage/AdeptImport/archive/v2.6.tar.gz"
      sha256 "a7a6e16d55ea78e4962bf77fa876df73275f3baf8b9636198e48bcec7bc2edc2"
    end

    # Lazily grab latest configuration
    resource "adept.config" do
      url "https://github.com/AdeptLanguage/Config.git"
    end
  end

  bottle do
    root_url "https://github.com/AdeptLanguage/homebrew-tap/releases/download/adept-2.5"
    rebuild 1
    sha256 cellar: :any,                 big_sur:      "34da6ce6e90c4d91b2baac553e89640cbbbc99847785599f0825bf524bfc5ff8"
    sha256 cellar: :any,                 catalina:     "e735f5a51336aa836dab10f6421725d40a0fda3e028f7142066c9004668ab90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4632b9d3057f9197e0fc5e9e776fecb7c0ba9245b5baf01df5e60132f246da9f"
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
