# azapi-subnet-tf

[Terraform 참고  - azapi_resource](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks/subnets?pivots=deployment-language-terraform)

- `azapi_resource` 를 사용하여 subnet을 생성 & 수정하는 예제 레포
- subnet 외의 다른 자원들은 모두 azurerm provider로 생성/업데이트/삭제

## 주의 사항
- `azapi_update_resource` 리소스는 쓰지 말 것!! update용 리소스가 아예 따로 생겨버리므로 관리 포인트가 늘어나게 됨.
- VNet을 생성할 때는 반드시 VNet만 생성한 뒤 추가로 azapi_resource로 subnet 생성
- 포털에서도 마찬가지로 VNet 생성 시에 디폴트 서브넷이 추가되지 않도록 조심하고 별도 subnet 생성 하지 않을 것.