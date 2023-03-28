@IsTest
private class Test {
    @IsTest
    private static void fail() {
        Assert.isTrue(false);
    }
}