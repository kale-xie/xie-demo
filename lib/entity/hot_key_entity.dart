class HotKeyEntity{
  List<HotKeyData>? data;
  int? errorCode;
  String? errorMsg;

  HotKeyEntity({this.data,this.errorCode,this.errorMsg});

  HotKeyEntity.fromJson(Map<dynamic, dynamic> json){
    if(json['data'] != null){
      data =List<HotKeyData>.empty(growable: true);
      (json['data'] as List).forEach((v) {data?.add( HotKeyData.fromJson(v)); });
    }
  }
}


class HotKeyData {
	int? visible;
	String? link;
	String? name;
	int? id;
	int? order;

	HotKeyData({this.visible, this.link, this.name, this.id, this.order});

	HotKeyData.fromJson(Map<String, dynamic> json) {
		visible = json['visible'];
		link = json['link'];
		name = json['name'];
		id = json['id'];
		order = json['order'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['visible'] = this.visible;
		data['link'] = this.link;
		data['name'] = this.name;
		data['id'] = this.id;
		data['order'] = this.order;
		return data;
	}
}