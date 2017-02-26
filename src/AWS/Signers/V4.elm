module AWS.Signers.V4 exposing (sign)

import AWS.Config exposing (Credentials)
import AWS.Signers.Canonical exposing (canonical, signedHeaders)
import AWS.Http exposing (UnsignedRequest, RequestParams)
import Date exposing (Date)
import Date.Format exposing (formatISO8601)
import Http
import Regex exposing (HowMany(All), regex)


-- http://docs.aws.amazon.com/waf/latest/developerguide/authenticating-requests.html


sign :
    AWS.Config.Service
    -> AWS.Config.Credentials
    -> Date
    -> UnsignedRequest a
    -> Result String (Http.Request a)
sign config creds date req =
    Http.request
        { method = req.method
        , headers =
            headers config
                |> addAuthorization config creds date
                |> addSessionToken creds
                |> List.map (\( key, val ) -> Http.header key val)
        , url = AWS.Http.url config.host req.path req.params
        , body = AWS.Http.body req.params
        , expect = Http.expectJson req.decoder
        , timeout = Nothing
        , withCredentials = False
        }
        |> Ok


algorithm : String
algorithm =
    "AWS4-HMAC-SHA256"


headers : AWS.Config.Service -> List ( String, String )
headers config =
    [ ( "Host", config.host ++ ":443" )
    , ( "Content-Type", jsonContentType config )
    ]


formatDate : Date -> String
formatDate date =
    date
        |> formatISO8601
        |> Regex.replace All
            (regex "([-:\\]|\\.\\d{3})")
            (\_ -> "")


addSessionToken :
    AWS.Config.Credentials
    -> List ( String, String )
    -> List ( String, String )
addSessionToken creds headers =
    creds.sessionToken
        |> Maybe.map
            (\token ->
                ( "x-amz-security-token", token ) :: headers
            )
        |> Maybe.withDefault headers


addAuthorization :
    AWS.Config.Service
    -> AWS.Config.Credentials
    -> Date
    -> List ( String, String )
    -> List ( String, String )
addAuthorization config creds date headers =
    [ ( "X-Amz-Date", formatDate date )
    , ( "Authorization", authorization creds date config headers )
    ]
        |> List.append headers


authorization : Credentials -> Date -> AWS.Config.Service -> List ( String, String ) -> String
authorization creds date config headers =
    [ "AWS4-HMAC-SHA256 Credentials="
        ++ creds.accessKeyId
        ++ "/"
        ++ credentialsString date config
    , "SignedHeaders="
        ++ signedHeaders headers
    , "Signature="
        ++ signature creds
    ]
        |> String.join ", "


credentialsString : Date -> AWS.Config.Service -> String
credentialsString date config =
    [ date |> formatDate |> String.slice 0 8
    , config.region
    , config.serviceName
    , "aws4_request"
    ]
        |> String.join "/"


signature : Credentials -> String
signature creds =
    ""


jsonContentType : AWS.Config.Service -> String
jsonContentType config =
    "application/x-amz-json-" ++ config.xAmzJsonVersion ++ "; charset=utf-8"
