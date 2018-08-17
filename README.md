# OlhoVivoSDK

![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)

Um framework simples para abstrair o uso da API OlhoVivo, disponibilizada pela SPTrans  
http://www.sptrans.com.br/

## Como usar:

É necessário em primeiro lugar criar uma instância do objeto OlhoVivo usando seu token.  
O token deve ser obtido através da SPTrans. 
```swift
let apiInstance = OlhoVivo(token: "meu_token")
```

### Autenticação:

A autenticação na API é feita através de uma chamada em um endpoint específico, enviando o token.
Quando recebe uma resposta `401 Unauthorized` em qualquer endpoint o framework chama o método de autorização até 3 vezes antes de desistir.
Essa autenticação é feita de forma automatica e transparente.

### Tratamento de erro:

Todos os métodos do framework aceitam como parâmetro opcional uma closure no formato  
`(Error) -> (Bool, TimeInterval)` 
Essa closure é chamada em caso de resposta inválida da api (exceto 401) e serve para que se possa decidir se deve tentar novamente a request ou não e em quanto tempo deve ocorrer essa nova tentativa. Ela também recebe o objeto `Error` que causou o problema para que possa ser usado nesse processo de decisão. Ex:

```swift
let retryClosure = { error in
    if error.code == 500 {
        return (true, 1) // tentar novamente depois de um segundo
    }
    return (false, 0) // não tentar novamente (o tempo é irrelevante nesse caso)
}

apiInstance.lines("termo de busca", nil, retryClosure) { lines, error in 
    // trata resposta em caso de sucesso
}
```
Adicionalmente, a closure que contém a resposta da API também contém seu próprio objeto `Error`.  
Caso a closure de "retry" exista, a mesma vai interceptar todos os erros da chamada, fazendo com que o objeto de erro da segunda closure passe a tratar exclusivamente de erros de parse. Do contrário ele recebe todos os erros.

### Formato da resposta:

Todos os métodos fornecem sua resposta através de uma closure genérica `ListResponseHandler<T>`  
```swift
public typealias ListResponseHandler<T: Decodable> = ([T]?, Error?) -> Void
```

### Buscas:

Os métodos que podem ser usados diretamente no objeto `OlhoVivo` são buscas genéricas de linhas e paradas, e também dos horários de chegada de um linha específica em uma parada específica:  

#### Buscar linha:

```swift
func lines(_ query: String, _ direction: OVLine.Direction? = nil,
           _ retryHandler: RetryHelperBlock? = nil,
           _ responseHandler: @escaping ListResponseHandler<OVLine>)
```
Retorna todas as linhas que atendam ao termo de pesquisa definido em `query`  
> Realiza uma busca das linhas do sistema com base no parâmetro informado. 
> Se a linha não é encontrada então é realizada uma busca fonetizada na denominação das linhas. 

#### Buscar parada (ponto de ônibus):

```swift
func stops(search: String, _ retryHandler: RetryHelperBlock? = nil,
           _ responseHandler: @escaping ListResponseHandler<OVStop>)
```
Retorna todas as paradas que atendam ao termo de pesquisa definido em `query`  
> Realiza uma busca fonética das paradas de ônibus do sistema com base no parâmetro informado. 
> A consulta é realizada no nome da parada e também no seu endereço de localização. 

#### Próximas chegadas de (linha) em (parada):

```swift
func nextArrivals(of line: OVLine, at stop: OVStop, _ retryHandler: RetryHelperBlock? = nil,
                  _ responseHandler: @escaping ListResponseHandler<OVPosition>)
```
Retorna as posições e estimativa de chegada de todos os veículos de uma linha em relação a uma parada.

### Consultas contextualizadas:

Além dessas pesquisas, os próprios objetos de resposta contém métodos que retornam pesquisas relacionadas a si mesmo, como por exemplo _todos os veículos rodando nesta linha_ ou _todas as paradas que atendem essa linha_.  
Esses métodos tem uma assinatura similar aos descritos acima.  

### Paradas:
#### - Próximas chegadas
```swift
func getNextArrivals(_ retryHandler: RetryHelperBlock? = nil,
                     _ responseHandler: @escaping ListResponseHandler<LineSummary>)
```
Retorna uma lista de todas as linhas que atendem essa parada. Dentro delas retorna cada veículo em circulação e a previsão de chegada na parada de referência. 
  
_Exemplo:_
```swift
let stop = OVStop()
stop.getNextArrivals { (lines, error) in

    guard let lines = lines, error == nil else {
        return
    }

    if let domPedro = lines.first(where: { $0.nameDestination == "PQ DOM PEDRO II" }) {
        domPedro.positionList.forEach({ vehicleP in
            if let estimation = vehicleP.formattedNextArrival() {
                print("O veículo nº \(vehicleP.prefix) chegará aqui em: \(estimation)")
            }
        })
    }
}
```
_Output:_  
`"O veículo nº 8765 chegará aqui em: 1 hora e 23 minutos"`  
`"O veículo nº 3412 chegará aqui em: 0 hora e 55 minutos"`  
`"O veículo nº 4590 chegará aqui em: 0 hora e 12 minutos"`  

### Linhas:
#### - Próximas chegadas
```swift
func getNextArrivals(_ retryHandler: RetryHelperBlock? = nil,
                     _ responseHandler: @escaping ListResponseHandler<OVStop>)
```
Retorna uma lista de todas as paradas atendidas por essa linha.  
Dentro delas retorna cada veículo em circulação nesta linha e a previsão de chegada na parada de referência. 
  
_Exemplo:_
```swift
let line = OVLine()
line.getNextArrivals { (stops, error) in
            
    guard let stops = stops, error == nil else {
        return
    }

    stops.forEach({ stop in
        let nextArrival = stop.arrivals?.compactMap{ $0 }
            .sorted(by: { $0.timeIntervalToNextArrival()! < $1.timeIntervalToNextArrival()! })
            .first!
        let stop = "Próxima chegada em \(stop.name) "
        let bus = "será \(nextArrival!.prefix) em "
        let prediction = nextArrival!.formattedNextArrival()!
        print(stop + bus + prediction)
    })
}
```
_Output:_  
`"Próxima chegada em ANA CINTRA B/C será 3412 em 1 hora e 34 minutos"`  
`"Próxima chegada em PARADA ROBERTO SELMI DEI B/C será 4590 em 0 hora e 49 minutos"`  

#### - Posição dos veículos
```swift
func getPositions(_ retryHandler: RetryHelperBlock? = nil,
                  _ responseHandler: @escaping ListResponseHandler<OVPosition>)
```
Retorna uma lista com as posições de todos os veículos operando nessa linha.  

_Exemplo:_
```swift
let line = OVLine()
line.getPositions { (positions, error) in
    guard let positions = positions, error == nil else {
        return
    }
    positions.forEach({ position in
        print("\(position.prefix) está em \(position.coords)")
    })
}
```
_Output:_  
`"9867 está em CLLocationCoordinate2D(latitude: -9.0, longitude: 67.909090000000006)"`  
`"..."`  

#### - Paradas
```swift
func getStops(_ retryHandler: RetryHelperBlock? = nil,
              _ responseHandler: @escaping ListResponseHandler<OVStop>)
```
Retorna uma lista com todos os pontos de ônibus atendidos por essa linha.  

_Exemplo:_
```swift
let line = OVLine()
line.getStops { (stops, error) in
    guard let stops = stops, error == nil else {
        return
    }
    _ = stops.compactMap { print($0.name) }
}
```
_Output:_  
`"ANA CINTRA B/C"`  
`"PARADA ROBERTO SELMI DEI B/C"`  
`"..."`  
