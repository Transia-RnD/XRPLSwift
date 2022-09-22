# ``XRPLSwift``

## Topics

### Address Codec

- ``AddressCodec``
- ``AddressCodecErrors``
- ``Utils``
- ``XrplCodec``

### Binary Codec

- ``BinaryParser``
- ``BinarySerializer``
- ``Definitions``
- ``binaryTypes``
- ``FieldHeader``
- ``FieldInfo``
- ``FieldInstance``

### Binary Codec (Types)

- ``AccountID``
- ``Amount``
- ``Blob``
- ``Currency``
- ``Hash``
- ``Hash128``
- ``Hash160``
- ``Hash256``
- ``PathSet``
- ``SerializedType``
- ``STArray``
- ``STObject``
- ``UInt8``
- ``UInt16``
- ``UInt32``
- ``UInt64``
- ``Vector256``

### Binary Codec (Utils)

- ``BinaryError``
- ``BytesList``
- ``getTypeByName``

### Keypairs

- ``Keypairs``
- ``KeypairsErrors``
- ``KeypairsUtils``

### Xrpl Clients

- ``XrplClient``
- ``XrplError``
- ``Connection``
- ``ConnectionManager``
- ``ExponentialBackoff``
- ``RequestManager``
- ``WSWrapper``

### Xrpl Sugar

- ``AutoFillSugar``
- ``BalancesSugar``
- ``GetFeeXrpSugar``
- ``GetOrderBookSugar``
- ``SubmitSugar``
- ``SugarUtils``

### Xrpl Models: Ledger Objects ("LO")

- ``AccountRoot``
- ``Amendments``
- ``BaseLedger``
- ``BaseLedgerEntry``
- ``Check``
- ``DepositPreauth``
- ``DirectoryNode``
- ``Escrow``
- ``FeeSettings``
- ``LedgerEntry``
- ``LedgerHashes``
- ``NegativeUNL``
- ``Offer``
- ``PayChannel``
- ``RippleStats``
- ``SignerList``
- ``Ticket``

### Xrpl Models: Methods

- ``AccountChannelsRequest``
- ``AccountChannelsResponse``
- ``AccountCurrenciesRequest``
- ``AccountCurrenciesResponse``
- ``AccountInfoRequest``
- ``AccountInfoResponse``
- ``AccountLinesRequest``
- ``AccountLinesResponse``
- ``AccountNFTsRequest``
- ``AccountNFTsResponse``
- ``AccountObjectsRequest``
- ``AccountObjectsResponse``
- ``AccountOffersRequest``
- ``AccountOffersResponse``
- ``AccountTxRequest``
- ``AccountTxResponse``
- ``BookOffersRequest``
- ``BookOffersResponse``
- ``ChannelVerifyRequest``
- ``ChannelVerifyResponse``
- ``DepositAuthorizedRequest``
- ``DepositAuthorizedResponse``
- ``FeeRequest``
- ``FeeResponse``
- ``GatewayBalancesRequest``
- ``GatewayBalancesResponse``
- ``LedgerRequest``
- ``LedgerResponse``
- ``LedgerClosedRequest``
- ``LedgerClosedResponse``
- ``LedgerCurrentRequest``
- ``LedgerCurrentResponse``
- ``LedgerDataRequest``
- ``LedgerDataResponse``
- ``LedgerEntryRequest``
- ``LedgerEntryResponse``
- ``ManifestRequest``
- ``ManifestResponse``
- ``NFTBuyOffersRequest``
- ``NFTBuyOffersResponse``
- ``NFTSellOffersRequest``
- ``NFTSellOffersResponse``
- ``NoRippleCheckRequest``
- ``NoRippleCheckResponse``
- ``PathFindRequest``
- ``PathFindResponse``
- ``PingRequest``
- ``PingResponse``
- ``RandomRequest``
- ``RandomResponse``
- ``RipplePathFindRequest``
- ``RipplePathFindResponse``
- ``ServerInfoRequest``
- ``ServerInfoResponse``
- ``ServerStateRequest``
- ``ServerStateResponse``
- ``SubmitRequest``
- ``SubmitResponse``
- ``SubmitMultisignedRequest``
- ``SubmitMultisignedResponse``
- ``SubscribeRequest``
- ``SubscribeResponse``
- ``UnsubscribeRequest``
- ``UnsubscribeResponse``
- ``TransactionEntryRequest``
- ``TransactionEntryResponse``
- ``TxRequest``
- ``TxResponse``

### Xrpl Models: Transactions

- ``AccountDelete``
- ``AccountSet``
- ``CheckCancel``
- ``CheckCash``
- ``DepositPreauth``
- ``EscrowCancel``
- ``EscrowCreate``
- ``EscrowFinish``
- ``NFTokenAcceptOffer``
- ``NFTokenBurn``
- ``NFTokenCancelOffer``
- ``NFTokenCreateOffer``
- ``NFTokenMint``
- ``OfferCancel``
- ``OfferCreate``
- ``Payment``
- ``PaymentChannelClaim``
- ``PaymentChannelCreate``
- ``PaymentChannelFund``
- ``SetRegularKey``
- ``SignerListSet``
- ``TicketCreate``
- ``TrustSet``

### Xrpl Utils

- ``deriveXAddress``
- ``GetBalanceChangesUtils``
- ``ParseNFTokenIDUtils``
- ``SignPaymentChannelClaimUtils``
- ``TimeConversionUtils``
- ``VerifyPaymentChannelClaimUtils``
- ``dropsToXrp``
- ``xrpToDrops``

### Xrpl Wallet

- ``FundWallet``
- ``Wallet``
- ``WalletSigner``
