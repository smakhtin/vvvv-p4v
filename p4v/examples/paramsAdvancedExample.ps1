function test-set {
    [CmdletBinding(DefaultParameterSetName = "BarSet")]
    param(
        [parameter(
            mandatory=$true,
            parametersetname="FooSet"
        )]
        [switch]$Foo,

        [parameter(
            mandatory=$true,
            position=0,
            parametersetname="BarSet"
        )]
        [string]$Bar,

        [parameter(
            mandatory=$true,
            position=1
        )]
        [io.fileinfo]$FilePath
    )
@"
  Parameterset is: {0}
  Bar is: '{1}'
  -Foo present: {2}
  FilePath: {3}
"@ -f $PSCmdlet.ParameterSetName, $bar, $foo.IsPresent, $FilePath
}