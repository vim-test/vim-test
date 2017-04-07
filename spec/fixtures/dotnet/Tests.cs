namespace Namespace
{
    public class Tests
    {
        [Fact]
        public async void TestAsync()
        {
            Assert.Equal(true, false);
        }

        [Fact]
        public void Test()
        {
            Assert.Equal(true, false);
        }
    }
}
