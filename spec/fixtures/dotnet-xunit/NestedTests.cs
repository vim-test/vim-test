using Xunit;

namespace Namespace
{
    public class Parent
    {
        public class NestedTests
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
}
