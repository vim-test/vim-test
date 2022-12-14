package vimtest.msg;

import junit.framework.TestCase;

public class MessageServiceTest extends TestCase {
  public void testGetMessage() {
    assertEquals(MessageService.getMessage(), "hello world");
  }
}
