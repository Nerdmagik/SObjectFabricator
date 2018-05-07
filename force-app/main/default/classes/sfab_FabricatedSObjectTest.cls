@isTest
private class sfab_FabricatedSObjectTest {
    @isTest
    private static void constructor_expectFieldsSet() {
        Map<Schema.SObjectField, Object> accountFields = new Map<SObjectField, Object> {
                Account.Id => 'Id-1',
                Account.Name => 'Foo'
        };

        sfab_FabricatedSObject fabricatedAccount = new sfab_FabricatedSObject(Account.class, accountFields);
        System.assertEquals(accountFields.size(), fabricatedAccount.nodes.size());
    }

    @isTest
    private static void toSObject_expectSpecifiedSObjectType() {
        SObject sObj = new sfab_FabricatedSObject(Account.class).toSObject();
        System.assert(sObj instanceof Account);
    }

    @isTest
    private static void toSObject_expectBuildInvokedOnNodes() {
        sfab_FabricatedSObjectNodeStub node1 = new sfab_FabricatedSObjectNodeStub();
        sfab_FabricatedSObjectNodeStub node2 = new sfab_FabricatedSObjectNodeStub();
        SObject sObj = new sfab_FabricatedSObject(Account.class, new List<sfab_FabricatedSObjectNode> { node1, node2 }).toSObject();
        System.assert(node1.serializeInvoked);
        System.assert(node2.serializeInvoked);
    }

    @isTest
    private static void toSObject_expectProperties() {
        Map<String, Object> fields = new Map<String, Object> { 'Id' => 'id-1', 'Name' => 'Foo' };
        sfab_FabricatedSObjectNodeStub node = new sfab_FabricatedSObjectNodeStub(fields);
        SObject sObj = new sfab_FabricatedSObject(Account.class, new List<sfab_FabricatedSObjectNode> { node }).toSObject();
        System.assertEquals(fields.get('Id'), sObj.Id);
        System.assertEquals(fields.get('Name'), sObj.get('Name'));
    }

    @isTest
    private static void setField_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.setField(Account.Id, 'Id-1');
        System.assertEquals(1, fabricatedSObject.nodes.size());
    }

    @isTest
    private static void setParent_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Opportunity.class);
        fabricatedSObject.setParent('Account', new sfab_FabricatedSObject(Account.class));
        System.assertEquals(1, fabricatedSObject.nodes.size());
    }

    @isTest
    private static void setChildren_expectFieldAdded() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.setChildren('Opportunites', new List<sfab_FabricatedSObject>());
        System.assertEquals(1, fabricatedSObject.nodes.size());
    }
    
    @isTest
    static void itShouldReturnSObjectType() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );
        system.assertEquals(User.SObjectType, fabricatedSObject.getSObjectType( User.class ));
    }
    
    
    @isTest
    static void itShouldReturnSObjectTypeOfInstanceType()
    {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );
        system.assertEquals( Account.SObjectType, fabricatedSObject.getSObjectType() );
    }
    
    
    @isTest
    static void itShouldReturnSObjectFieldType() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );
        Schema.SObjectField idField = Account.Id.getDescribe().getSObjectField();
        system.assertEquals( idField, fabricatedSObject.getSObjectField( 'Id' )  );
    }
    
    
    @isTest
    static void itShouldSetTheIdFieldOfTheCurrentSObject()
    {
        Account acct = (Account) new sfab_FabricatedSObject( Account.class )
          .setFakeId()
          .toSObject();
        
        String strId = (String) acct.Id;
    
        system.assertEquals( 18, strId.length() );
        system.assertEquals( '001', strId.left( 3 ) );
        system.assertEquals( 'AAA', strId.right( 3 ) );
        system.assertEquals( '000000000001', strId.mid( 3, 12 ) );
    }
    
    
    @isTest
    static void itShouldSetTheIdOnARelationshipFieldUsingGenericType()
    {
        Account acct = (Account) new sfab_FabricatedSObject( Account.class )
          .setFakeId( Account.OwnerId, User.class )
          .toSObject();
        
        String strId = (String) acct.OwnerId;
        
        system.assertEquals( 18, strId.length() );
        system.assertEquals( '005', strId.left( 3 ) );
        system.assertEquals( 'AAA', strId.right( 3 ) );
        system.assertEquals( '000000000001', strId.mid( 3, 12 ) );
    }
    
    
    @isTest
    static void itShouldSetTheIdOnARelationshipFieldUsingSObjectType()
    {
        Account acct = (Account) new sfab_FabricatedSObject( Account.class )
          .setFakeId( Account.OwnerId, User.SObjectType )
          .toSObject();
    
        String strId = (String) acct.OwnerId;
    
        system.assertEquals( 18, strId.length() );
        system.assertEquals( '005', strId.left( 3 ) );
        system.assertEquals( 'AAA', strId.right( 3 ) );
        system.assertEquals( '000000000001', strId.mid( 3, 12 ) );
    }
    
    
    @isTest
    static void itShouldSetTimestampFields()
    {
        Account acct = (Account) new sfab_FabricatedSObject( Account.class )
          .setTimestamps()
          .toSObject();
    
        String strCreatedById = (String) acct.CreatedById;
        String strModifiedById = (String) acct.LastModifiedById;
        
        system.assertEquals( '005', strCreatedById.left( 3 ) );
        system.assertEquals( '005', strModifiedById.left( 3 ) );
        system.assertEquals( Datetime.now(), acct.CreatedDate);
        system.assertEquals( Datetime.now(), acct.LastModifiedDate);
    }
  
  
    @isTest
    static void itShouldSetTimestampFieldsToSpecifiedDate()
    {
        Account acct = (Account) new sfab_FabricatedSObject( Account.class )
          .setTimestamps(Datetime.now().addDays(-1))
          .toSObject();
        
        String strCreatedById = (String) acct.CreatedById;
        String strModifiedById = (String) acct.LastModifiedById;
        
        system.assertEquals( '005', strCreatedById.left( 3 ) );
        system.assertEquals( '005', strModifiedById.left( 3 ) );
        system.assertEquals( Datetime.now().addDays(-1), acct.CreatedDate );
        system.assertEquals( Datetime.now().addDays( -1 ), acct.LastModifiedDate );
    }
}