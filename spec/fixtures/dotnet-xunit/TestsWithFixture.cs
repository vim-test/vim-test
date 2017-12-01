using Xunit;

namespace Namespace
{
    public class MyFixture
    {
        public int Test { get; } = 1;
    }

    public class TestsWithFixture : IClassFixture<MyFixture>
    {
        private readonly MyFixture _fixture;

        public TestsWithFixture(MyFixture fixture)
        {
            _fixture = fixture;
        }

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
