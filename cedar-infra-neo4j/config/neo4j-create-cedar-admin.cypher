UNWIND [{
	_id:"https://metadatacenter.org/users/ab2a9696-291f-4705-b5e6-6c262266c506",
	properties:{
		lastName:"Admin",
		lastUpdatedOnTS:1598574585,
		roles:[
			"defaultUser",
			"templateCreator",
			"metadataCreator",
			"userAdministrator",
			"groupAdministrator",
			"filesystemAdministrator",
			"categoryAdministrator",
			"categoryPrivilegedAdministrator",
			"searchReindexer",
			"processMessageSender"
		],
		uiPreferences:"{\"folderView\":{\"currentFolderId\":null,\"sortBy\":\"name\",\"sortDirection\":\"asc\",\"viewMode\":\"grid\"},\"resourceTypeFilters\":{\"field\":true,\"element\":true,\"template\":true,\"instance\":true},\"resourcePublicationStatusFilter\":{\"publicationStatus\":\"all\"},\"resourceVersionFilter\":{\"version\":\"all\"},\"infoPanel\":{\"opened\":false,\"activeTab\":\"info\"},\"templateEditor\":{\"templateJsonViewer\":false},\"metadataEditor\":{\"templateJsonViewer\":false,\"metadataJsonViewer\":false},\"stylesheet\":\"default\"}", apiKeys:["<cedar.CEDAR_ADMIN_USER_API_KEY>"], schema_name:"CEDAR Admin", createdOnTS:1598574581, pav_lastUpdatedOn:"2020-08-27T17:29:45-07:00", firstName:"CEDAR", homeFolderId:null, pav_createdOn:"2020-08-27T17:29:41-07:00", apiKeyMap:"{\"<cedar.CEDAR_ADMIN_USER_API_KEY>\":{\"key\":\"<cedar.CEDAR_ADMIN_USER_API_KEY>\",\"serviceName\":\"CEDAR\",\"description\":\"Auto-generated apiKey for CEDAR\",\"creationDate\":\"2020-08-27T17:29:41.29902\",\"enabled\":true}}",
		permissions:[
			"permission_category_create",
			"permission_category_delete",
			"permission_category_read",
			"permission_category_update",
			"permission_element_create",
			"permission_element_delete",
			"permission_element_read",
			"permission_element_update",
			"permission_field_create",
      "permission_field_delete",
      "permission_field_read",
      "permission_field_update",
      "permission_folder_create",
      "permission_folder_delete",
      "permission_folder_read",
      "permission_folder_update",
      "permission_group_create",
      "permission_group_delete",
      "permission_group_read",
      "permission_group_update",
      "permission_instance_create",
      "permission_instance_delete",
      "permission_instance_read",
      "permission_instance_update",
      "permission_logged_in_read",
      "permission_not_administered_group_update",
      "permission_not_readable_node_read",
      "permission_not_writable_category_permissions_update",
      "permission_not_writable_category_write",
      "permission_not_writable_node_permissions_update",
      "permission_not_writable_node_write",
      "permission_process_message_create",
      "permission_rules_index_create",
      "permission_search_index_create",
      "permission_template_create",
      "permission_template_delete",
      "permission_template_read",
      "permission_template_update",
      "permission_user_read",
      "permission_user_update"
    ],
		email:"cedar-admin@<cedar.CEDAR_HOST>",
		resourceType:"user"
	}
}] AS row
CREATE (n:Resource {_id: row._id}) SET n += row.properties SET n:User;
