@IsTest
private class Test {
    // @IsTest
    // private static void success() {
    //     Assert.isTrue(true);
    // }

    @IsTest
    private static void fail() {
        Assert.isTrue(false);
    }
}