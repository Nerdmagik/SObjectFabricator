@IsTest
private class sfab_FabricatedSObjectIdTest
{
  
  @isTest
  static void idShouldGenerateAn18CharAccountId()
  {
    String id = (String) sfab_FabricatedSObjectId.getFakeId( Account.SObjectType );
    system.assertEquals( 18, id.length() );
    system.assertEquals( '001', id.left( 3 ) );
    system.assertEquals( 'AAA', id.right( 3 ) );
    system.assertEquals( '000000000001', id.mid( 3, 12 ) );
  }
  
  
  @isTest
  static void itShouldIncrement()
  {
    String id1 = (String) sfab_FabricatedSObjectId.getFakeId( Account.SObjectType );
    String id2 = (String) sfab_FabricatedSObjectId.getFakeId( Contact.SObjectType );
    String id3 = (String) sfab_FabricatedSObjectId.getFakeId( User.SObjectType );
    system.assertEquals( '000000000001', id1.mid( 3, 12 ) );
    system.assertEquals( '000000000002', id2.mid( 3, 12 ) );
    system.assertEquals( '000000000003', id3.mid( 3, 12 ) );
  }
  
  
  @isTest
  static void itShouldUseTheCorrectSObjectPrefix()
  {
    String id1 = (String) sfab_FabricatedSObjectId.getFakeId( Account.SObjectType );
    String id2 = (String) sfab_FabricatedSObjectId.getFakeId( Contact.SObjectType );
    String id3 = (String) sfab_FabricatedSObjectId.getFakeId( User.SObjectType );
    system.assertEquals( '001', id1.left( 3 ) );
    system.assertEquals( '003', id2.left( 3 ) );
    system.assertEquals( '005', id3.left( 3 ) );
  }
  
  
  @isTest
  static void itShouldAcceptGenericTypes()
  {
    String id = (String) sfab_FabricatedSObjectId.getFakeId( Account.class );
    system.assertEquals( 18, id.length() );
    system.assertEquals( '001', id.left( 3 ) );
    system.assertEquals( 'AAA', id.right( 3 ) );
    system.assertEquals( '000000000001', id.mid( 3, 12 ) );
  }
}