
# Yandex.Cloud-OpenShift
Terraform template for installation Terraform in Yandex Cloud
Для работы примера нужно:
<ol>
  <li>Перейти в папку "terraform" и переименовать файл terraform.example.tfvars в terraform.tfvars</li>
  <li>В файле terraform.tfvars перереопределить переменные yc_cloud_id, yc_folder_id, yc_main_zone в соотв. с настройками Вашего тенанта.</li>
<li>Выполнить инициализацию с помощью команды:
<pre><code>$ terraform init
</code></pre>
</li>
<li>
<p><em>Проверить корректность конфигурационных файлов с помощью команды:.</em></p>
<pre><code>$ terraform plan
</code></pre>
</li>
<li>
<p>Если конфигурация описана верно, в терминале отобразится список создаваемых ресурсов и их параметров.
  Если в конфигурации есть ошибки, Terraform на них укажет.</p>
</li>
<li><p>Развернуть облачные ресурсы.</p>
  <div><em> Если в конфигурации нет ошибок, выполните команду:</em></div>
<pre><code>$ terraform apply
</code></pre>
</li>
<li>Подтвердить создание ресурсов.</li>
</ol>