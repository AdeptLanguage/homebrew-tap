class Adept < Formula
  desc "Blazing fast language for general purpose programming"
  homepage "https://github.com/AdeptLanguage/Adept"
  license "GPL-3.0"

  head do
    url "https://github.com/AdeptLanguage/Adept.git"

    resource "import" do
      url "https://github.com/AdeptLanguage/AdeptImport.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "llvm@9"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "adept"
    (bin/"import").install resource("import")
  end

  test do
    (testpath/"test.adept").write <<~EOS
      import '2.3/basics.adept'
      func main {
        print("Hello World!")
      }
    EOS
    system bin/"adept", "test.adept"
    assert_match "Hello World!", shell_output("./test")
  end
end
